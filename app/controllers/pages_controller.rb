class PagesController < ApplicationController
  before_action :require_shift, only: %i[host host_floor host_confirmations]

  def opening
  end

  def host
    @shift = current_shift
    pending = @shift.parties.where(confirmation_status: %w[pending no_answer]).where(source: "reservation").count

    @metrics = [
      { label: "Covers booked", value: @shift.parties.sum(:covers).to_s, detail: "across #{@shift.parties.where(source: "reservation").count} reservations", accent: false },
      { label: "Staff on", value: @shift.server_shifts.count.to_s, detail: "#{@shift.server_shifts.count - 1} servers · 1 floater", accent: false },
      { label: "Confirmations pending", value: pending.to_s, detail: "call before 5:30", accent: true },
      { label: "Walk-ins forecast", value: "~28", detail: "peak 8–9 pm", accent: false }
    ]

    @sections = @shift.sections.includes(:server_shift, :dining_tables)
    @reservations = @shift.parties.for_book.limit(7)
    @server_shifts = @shift.server_shifts.active.includes(:server).order(:start_order)
  end

  def host_floor
    @shift = current_shift
    @show_cut_modal = params[:cut] == "1" || flash[:show_cut_modal]
    @floor_metrics = [
      { label: "Covers", value: @shift.parties.where(lifecycle: "seated").sum(:covers).to_s },
      { label: "Covers / hr", value: "11.4" },
      { label: "Servers on", value: @shift.server_shifts.active.count.to_s },
      { label: "Waitlist", value: "#{@shift.parties.in_queue.count} · 25 min" }
    ]

    @server_rows = @shift.sections.includes(:server_shift, :dining_tables).filter_map do |section|
      next unless section.server_shift

      {
        label: "#{section.server_shift.name} · #{section.name}",
        tables: section.dining_tables.map { |table|
          party = table.active_party
          {
            id: table.label,
            capacity: table.capacity_label,
            guest: table.guest_label,
            covers: party&.covers,
            seated: table.seated_duration_label,
            status: table.status.to_sym
          }
        }
      }
    end

    @queue = @shift.parties.in_queue.includes(seating_recommendation: [ :dining_table, { server_shift: :server } ])
    @pacing = @shift.rush_mode? ? nil : @shift.open_pacing_recommendation
    @cut = @shift.open_cut_recommendation
    @alternate_options = @queue.index_with { |party| Seating::AssignmentEngine.alternatives(party: party) }
  end

  def host_confirmations
    @shift = current_shift
    @confirmation_counts = @shift.confirmation_counts
    @confirmation_calls = @shift.parties.for_confirmation_calls
  end

  def manager
  end

  private

  def current_shift
    @current_shift ||= Shift.current
  end

  def require_shift
    return if current_shift

    redirect_to root_path, alert: "No shift data yet. Run bin/rails db:seed"
  end
end
