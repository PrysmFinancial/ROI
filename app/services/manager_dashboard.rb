class ManagerDashboard
  WEEDS_DELTA = 1.5
  LIGHT_DELTA = -1.0

  def self.call(shift:)
    new(shift).call
  end

  def initialize(shift)
    @shift = shift
  end

  def call
    {
      location_name: shift.location_name,
      rush_mode: shift.rush_mode?,
      kpis: kpis,
      floor_status: floor_status,
      servers_on: servers_on,
      pacing: pacing,
      tonight_feed: tonight_feed,
      tools: ManagerDemo.tools
    }
  end

  private

  attr_reader :shift

  def kpis
    floor = Host::Metrics.floor(shift)
    covers_hr = floor.find { |m| m[:label] == "Covers / hr" }[:value]
    waitlist = floor.find { |m| m[:label] == "Waitlist" }[:value]
    seated_covers = shift.parties.where(lifecycle: "seated").sum(:covers)
    active = shift.server_shifts.active
    servers_detail = if open_cut
      "cut rec · #{open_cut.server_shift.name}"
    else
      "#{active.count} on floor"
    end
    queue = shift.parties.in_queue
    wait_detail = if (minutes = queue.filter_map(&:quoted_wait_minutes).max)
      "quoted #{minutes} min"
    else
      "#{queue.count} waiting"
    end

    [
      { label: "Covers tonight", value: seated_covers.to_s, detail: vs_prior_detail, tone: covers_tone },
      { label: "Covers / hr", value: covers_hr, detail: "floor average", tone: :neutral },
      { label: "Net sales", value: "$#{shift.net_sales.to_fs(:delimited)}", detail: vs_prior_detail, tone: covers_tone },
      { label: "Avg turn", value: "#{shift.avg_turn_minutes} min", detail: turn_detail, tone: turn_tone },
      { label: "Servers on", value: active.count.to_s, detail: servers_detail, tone: :neutral },
      { label: "Waitlist", value: waitlist.split(" · ").first, detail: wait_detail, tone: :neutral }
    ]
  end

  def vs_prior_detail
    pct = shift.covers_vs_prior_pct
    return "vs prior Friday" if pct.zero?

    "▲ #{pct}% vs. last Fri"
  end

  def covers_tone
    shift.covers_vs_prior_pct.positive? ? :up : :neutral
  end

  def turn_detail
    delta = shift.turn_vs_prior_minutes
    return "on prior Friday" if delta.zero?

    "▼ #{delta} min slower"
  end

  def turn_tone
    shift.turn_vs_prior_minutes.positive? ? :down : :neutral
  end

  def floor_status
    tables = DiningTable.joins(:section).where(sections: { shift_id: shift.id })
    [
      { label: "Seated", value: tables.where(status: "seated").count, tone: :seated },
      { label: "Bill", value: tables.where(status: "bill").count, tone: :bill },
      { label: "Held", value: tables.where(status: "held").count, tone: :held },
      { label: "Open", value: tables.where(status: "open").count, tone: :open }
    ]
  end

  def servers_on
    shift.server_shifts.active.includes(:server, :section).order(:start_order).map do |ss|
      baseline = ss.server.baseline_covers_per_hour.to_f
      cov_hr = ss.covers_per_hour.to_f
      delta = (cov_hr - baseline).round(1)
      {
        name: ss.name,
        section: ss.section&.name || "Unassigned",
        covers: ss.covers_tonight,
        pace: pace_label(delta),
        cov_hr: format("%.1f", cov_hr),
        vs_base: format_delta(delta),
        vs_tone: delta >= 0 ? :up : :down,
        badge: badge_for(delta)
      }
    end
  end

  def pacing
    tables = DiningTable.joins(:section).where(sections: { shift_id: shift.id })
    total = tables.count
    seated = tables.where(status: "seated").count
    floor_pct = total.zero? ? 0 : ((seated.to_f / total) * 100).round

    {
      kitchen_pct: shift.kitchen_load_pct,
      floor_label: floor_pct >= 70 ? "Busy" : "On pace",
      floor_pct: floor_pct,
      late_demand: shift.late_demand_label.presence || "—",
      late_pct: shift.late_demand_pct,
      cut: open_cut && {
        name: open_cut.server_shift.name,
        time: open_cut.created_at.strftime("%-l:%M")
      }
    }
  end

  def tonight_feed
    shift.decision_events.order(created_at: :desc, id: :desc).limit(6).map do |event|
      {
        time: event.created_at.strftime("%-l:%M"),
        text: event.summary
      }
    end
  end

  def open_cut
    @open_cut ||= shift.open_cut_recommendation
  end

  def pace_label(delta)
    if delta >= 1.0
      "High."
    elsif delta >= 0
      "On pace."
    elsif delta >= -0.8
      "Easing."
    else
      "Light."
    end
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
end
