module Seating
  class AssignmentEngine
    def self.call(party:)
      new(party).call
    end

    def initialize(party)
      @party = party
      @shift = party.shift
    end

    def call
      candidates = eligible_server_shifts
      return nil if candidates.empty?

      ranked = candidates.sort_by { |ss| [ -idle_score(ss), ss.covers_tonight, ss.start_order, ss.id ] }
      server_shift = ranked.first
      table = best_table_for(server_shift)
      return nil unless table

      summary = "ROI recommends #{table.label} · #{server_shift.name}"
      recommendation = party.seating_recommendation || party.build_seating_recommendation
      recommendation.update!(
        dining_table: table,
        server_shift: server_shift,
        summary: summary,
        status: "open"
      )
      recommendation
    end

    private

    attr_reader :party, :shift

    def eligible_server_shifts
      shift.server_shifts
        .active
        .includes(:server, section: :dining_tables)
        .select { |ss| ss.section.present? && fitting_tables(ss).any? }
    end

    def fitting_tables(server_shift)
      server_shift.section.dining_tables.open_for_seating.select { |t| t.capacity >= party.covers }
    end

    def best_table_for(server_shift)
      fitting_tables(server_shift).min_by { |t| [ t.capacity, t.label ] }
    end

    def idle_score(server_shift)
      open_count = server_shift.section.dining_tables.open_for_seating.count
      open_count
    end
  end
end
