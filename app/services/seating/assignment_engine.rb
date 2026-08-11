module Seating
  class AssignmentEngine
    def self.call(party:)
      new(party).call
    end

    def self.alternatives(party:)
      new(party).alternatives
    end

    def initialize(party)
      @party = party
      @shift = party.shift
    end

    def call
      candidates = eligible_assignments
      return nil if candidates.empty?

      ranked = candidates.sort_by { |assignment| [ -composite_score(assignment), assignment[:server_shift].start_order, assignment[:server_shift].id ] }
      best = ranked.first

      summary = "ROI recommends #{best[:label]} · #{best[:server_shift].name}"
      recommendation = party.seating_recommendation || party.build_seating_recommendation
      recommendation.update!(
        dining_table: best[:dining_table],
        server_shift: best[:server_shift],
        summary: summary,
        status: "open"
      )
      recommendation
    end

    # Legal alternate table/server pairings for this party (excludes the current open recommendation).
    def alternatives
      current = party.seating_recommendation
      eligible_assignments.filter_map do |assignment|
        next if current&.status == "open" &&
          current.dining_table_id == assignment[:dining_table].id &&
          current.server_shift_id == assignment[:server_shift].id

        {
          dining_table: assignment[:dining_table],
          server_shift: assignment[:server_shift],
          label: "#{assignment[:label]} · #{assignment[:server_shift].name}"
        }
      end.sort_by { |o| [ o[:dining_table].label, o[:server_shift].name ] }
    end

    private

    attr_reader :party, :shift

    # Hard filters: cut protection + section fit (incl. combinable pairs).
    # Soft scores (equal weight): fairness, availability/idle, projected availability, efficiency.
    # VIP/capability hard filters deferred until self-baseline hustle (D-01).
    def eligible_assignments
      options = []

      serving_server_shifts.each do |server_shift|
        fitting_options_for(server_shift).each do |fit|
          options << fit.merge(server_shift: server_shift)
        end
      end

      options
    end

    def serving_server_shifts
      shift.server_shifts
        .active
        .includes(:server, section: :dining_tables)
        .select { |ss| sections_for(ss).any? }
    end

    def sections_for(server_shift)
      owned = server_shift.section
      pickups = shift.sections.select { |section| section.pickup_server_shift_id == server_shift.id }
      ([ owned ] + pickups).compact.uniq
    end

    def fitting_options_for(server_shift)
      sections_for(server_shift).flat_map do |section|
        open_tables = section.dining_tables.select { |t| t.status == "open" }
        singles = open_tables.select { |t| t.capacity >= party.covers }.map do |table|
          { dining_table: table, label: table.label, combo: false, section: section }
        end
        next singles if singles.any?

        combinable = open_tables.select(&:combinable)
        combos = []
        combinable.combination(2).each do |a, b|
          next unless a.capacity + b.capacity >= party.covers

          primary = [ a, b ].max_by { |t| [ t.capacity, t.label ] }
          left, right = [ a, b ].minmax_by(&:label)
          combos << {
            dining_table: primary,
            label: "#{left.label}+#{right.label}",
            combo: true,
            section: section
          }
        end
        combos
      end
    end

    def composite_score(assignment)
      fairness_score(assignment[:server_shift]) +
        availability_score(assignment[:server_shift], assignment[:section]) +
        projected_availability_score(assignment[:section]) +
        efficiency_score(assignment[:server_shift])
    end

    def fairness_score(server_shift)
      avg = average_covers
      return 1.0 if avg.zero?

      ratio = server_shift.covers_tonight.to_f / avg
      band = 1 + Seating::Config::FAIRNESS_BAND
      return 1.0 if ratio <= band

      [ 0.0, 1.0 - (ratio - band) ].max
    end

    def availability_score(server_shift, section)
      idle = idle_minutes(server_shift, section)
      return 1.0 if idle >= Seating::Config::IDLE_MINUTES
      return 0.5 if idle.positive?

      0.0
    end

    def projected_availability_score(section)
      return 0.0 unless section

      total = section.dining_tables.size
      return 0.0 if total.zero?

      open = section.dining_tables.count { |t| t.status == "open" }
      open.to_f / total
    end

    def efficiency_score(server_shift)
      baseline = server_shift.server.baseline_covers_per_hour.to_f
      return 0.5 if baseline <= 0

      ratio = server_shift.covers_per_hour.to_f / baseline
      [ [ ratio, 1.5 ].min / 1.5, 0.0 ].max
    end

    def idle_minutes(server_shift, section)
      return 0 unless section

      last_seat = section.dining_tables.select { |t| t.status == "seated" && t.seated_at }.map(&:seated_at).max
      anchor = last_seat || server_shift.clocked_in_at || Time.current
      [ ((Time.current - anchor) / 60).floor, 0 ].max
    end

    def average_covers
      @average_covers ||= begin
        pool = serving_server_shifts
        return 0 if pool.empty?

        pool.sum(&:covers_tonight).to_f / pool.size
      end
    end
  end
end
