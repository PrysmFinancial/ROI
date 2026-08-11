module Host
  class Metrics
    def self.pre_shift(shift)
      new(shift).pre_shift
    end

    def self.floor(shift)
      new(shift).floor
    end

    def initialize(shift)
      @shift = shift
    end

    def pre_shift
      pending = shift.parties.where(confirmation_status: %w[pending no_answer], source: "reservation").count
      server_count = shift.server_shifts.count
      floater = [ server_count - shift.sections.where.not(server_shift_id: nil).count, 0 ].max
      servers_on_sections = server_count - floater
      forecast = shift.walk_in_forecast
      forecast_label = forecast.positive? ? "~#{forecast}" : "—"

      [
        {
          label: "Covers booked",
          value: shift.parties.sum(:covers).to_s,
          detail: "across #{shift.parties.where(source: "reservation").count} reservations",
          accent: false
        },
        {
          label: "Staff on",
          value: server_count.to_s,
          detail: "#{servers_on_sections} servers · #{floater} floater",
          accent: false
        },
        {
          label: "Confirmations pending",
          value: pending.to_s,
          detail: "call before 5:30",
          accent: true
        },
        {
          label: "Walk-ins forecast",
          value: forecast_label,
          detail: shift.walk_in_forecast_detail.presence || "from seed",
          accent: false
        }
      ]
    end

    def floor
      active = shift.server_shifts.active
      covers_hr = if active.any?
        (active.sum { |ss| ss.covers_per_hour.to_f } / active.size).round(1)
      else
        0
      end
      queue = shift.parties.in_queue
      wait_minutes = queue.filter_map(&:quoted_wait_minutes).max

      waitlist_value = if wait_minutes
        "#{queue.count} · #{wait_minutes} min"
      else
        queue.count.to_s
      end

      [
        { label: "Covers", value: shift.parties.where(lifecycle: "seated").sum(:covers).to_s },
        { label: "Covers / hr", value: covers_hr.to_s },
        { label: "Servers on", value: active.count.to_s },
        { label: "Waitlist", value: waitlist_value }
      ]
    end

    private

    attr_reader :shift
  end
end
