class ManagerStaffing
  def self.call(shift:)
    new(shift).call
  end

  def initialize(shift)
    @shift = shift
  end

  def call
    {
      presift: presift,
      cut: cut
    }
  end

  private

  attr_reader :shift

  def presift
    {
      forecast: forecast_label,
      body: plan_body,
      sections_approved: shift.sections_approved?,
      sections_approved_at: shift.sections_approved_at
    }
  end

  def forecast_label
    covers = shift.staffing_forecast_covers
    covers.positive? ? "#{covers} covers" : "#{booked_covers + shift.walk_in_forecast} covers"
  end

  def plan_body
    return shift.staffing_plan_body if shift.staffing_plan_body.present?

    server_count = shift.server_shifts.count
    floater = [ server_count - shift.sections.where.not(server_shift_id: nil).count, 0 ].max
    servers_on_sections = server_count - floater
    staffing = floater.positive? ? "#{servers_on_sections} servers + #{floater} floater" : "#{servers_on_sections} servers"
    "ROI recommends #{staffing}."
  end

  def booked_covers
    shift.parties.sum(:covers)
  end

  def cut
    recommendation = shift.open_cut_recommendation
    return unless recommendation

    server_shift = recommendation.server_shift
    section = server_shift.section
    tables = DiningTable.joins(:section).where(sections: { shift_id: shift.id })
    total = tables.count
    seated = tables.where(status: "seated").count
    floor_pct = total.zero? ? 0 : ((seated.to_f / total) * 100).round
    baseline = server_shift.server.baseline_covers_per_hour.to_f
    delta = server_shift.covers_per_hour.to_f - baseline

    {
      record: recommendation,
      time: recommendation.created_at.strftime("%-l:%M %p"),
      initial: server_shift.initial,
      name: server_shift.name,
      section: section&.name || "Unassigned",
      meta: "#{server_shift.covers_tonight} covers · #{pace_label(delta)} · #{hours_on(server_shift, recommendation.created_at)}",
      reason: recommendation.reason,
      floor_load_pct: floor_pct,
      late_demand: shift.late_demand_label.presence || "—",
      late_pct: shift.late_demand_pct
    }
  end

  def pace_label(delta)
    if delta >= 1.0
      "pace high"
    elsif delta >= 0
      "on pace"
    elsif delta >= -0.8
      "pace easing"
    else
      "light load"
    end
  end

  def hours_on(server_shift, as_of)
    return "—" unless server_shift.clocked_in_at

    minutes = ((as_of - server_shift.clocked_in_at) / 60).floor
    return "—" if minutes.negative?

    hours = minutes / 60
    mins = minutes % 60
    "#{hours}h #{mins}m on"
  end
end
