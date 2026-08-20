class ManagerPerformanceTable
  WEEDS_DELTA = 1.5
  LIGHT_DELTA = -1.0

  def self.call(shift:)
    new(shift).call
  end

  def initialize(shift)
    @shift = shift
  end

  def call
    rows = ranked_rows
    {
      rows: rows,
      insight: insight_for(rows)
    }
  end

  private

  attr_reader :shift

  def ranked_rows
    shift.server_shifts.active
      .includes(:server, :section)
      .sort_by { |server_shift| -server_shift.covers_per_hour.to_f }
      .map { |server_shift| row_for(server_shift) }
  end

  def row_for(server_shift)
    baseline = server_shift.server.baseline_covers_per_hour.to_f
    cov_hr = server_shift.covers_per_hour.to_f
    delta = (cov_hr - baseline).round(1)

    {
      name: server_shift.name,
      section: server_shift.section&.name || "Unassigned",
      covers: server_shift.covers_tonight,
      cov_hr: format("%.1f", cov_hr),
      vs_base: format_delta(delta),
      vs_tone: delta >= 0 ? :up : :down,
      efficiency: "#{efficiency_pct(server_shift)}%",
      fairness: fairness_pct(server_shift),
      badge: badge_for(delta)
    }
  end

  def average_covers
    @average_covers ||= begin
      pool = shift.server_shifts.active
      return 0 if pool.empty?

      pool.sum(&:covers_tonight).to_f / pool.size
    end
  end

  def fairness_pct(server_shift)
    avg = average_covers
    return 100 if avg.zero?

    ratio = server_shift.covers_tonight.to_f / avg
    band = 1 + Seating::Config::FAIRNESS_BAND
    score = if ratio <= band
      1.0
    else
      [ 0.0, 1.0 - (ratio - band) ].max
    end

    (score * 100).round
  end

  def efficiency_pct(server_shift)
    baseline = server_shift.server.baseline_covers_per_hour.to_f
    return 0 if baseline <= 0

    pct = (server_shift.covers_per_hour.to_f / baseline * 100).round
    [ [ pct, 100 ].min, 0 ].max
  end

  def badge_for(delta)
    return "In the weeds" if delta >= WEEDS_DELTA
    return "Light" if delta <= LIGHT_DELTA

    nil
  end

  def format_delta(delta)
    sign = delta.positive? || delta.zero? ? "+" : "−"
    "#{sign}#{format("%.1f", delta.abs)}"
  end

  def insight_for(rows)
    weeds = rows.find { |row| row[:badge] == "In the weeds" }
    if weeds
      "#{weeds[:name]} is flagged in the weeds — consider routing the next two parties elsewhere."
    else
      "Fairness weighs covers and section difficulty so no one server is buried while another coasts."
    end
  end
end
