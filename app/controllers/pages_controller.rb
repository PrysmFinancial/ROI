class PagesController < ApplicationController
  before_action :require_shift, only: %i[host host_floor host_confirmations host_decisions]

  def opening
  end

  def host
    @shift = current_shift
    @metrics = Host::Metrics.pre_shift(@shift)
    @sections = @shift.sections.includes(:server_shift, :pickup_server_shift, :dining_tables)
    @book_parties = @shift.parties.for_book
    @reservations = @book_parties.limit(7)
    @server_shifts = @shift.server_shifts.active.includes(:server).order(:start_order)
  end

  def host_floor
    @shift = current_shift
    @show_cut_modal = params[:cut] == "1" || flash[:show_cut_modal]
    @floor_metrics = Host::Metrics.floor(@shift)

    @server_rows = @shift.sections.includes(:server_shift, :pickup_server_shift, :dining_tables).filter_map do |section|
      next unless section.server_shift

      cut = section.server_shift.cut_status == "approved"
      pickup_note = section.pickup_server_shift ? " · pickup #{section.pickup_server_shift.name}" : ""
      cut_note = cut ? " · cut" : ""

      {
        label: "#{section.server_shift.name} · #{section.name}#{cut_note}#{pickup_note}",
        tables: section.dining_tables.map { |table|
          party = table.active_party
          {
            record_id: table.id,
            id: table.label,
            capacity: table.capacity_label,
            guest: table.guest_label,
            covers: party&.covers,
            seated: table.seated_duration_label,
            status: table.status.to_sym,
            mock_pickup: cut && table.status == "seated"
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

  def host_decisions
    @shift = current_shift
    @decision_events = @shift.decision_events.includes(:party).order(created_at: :desc, id: :desc)
  end

  def manager
    @kpis = ManagerDemo.kpis
    @floor_status = ManagerDemo.floor_status
    @servers_on = ManagerDemo.servers_on
    @pacing = ManagerDemo.pacing
    @tonight_feed = ManagerDemo.tonight_feed
    @tools = ManagerDemo.tools
  end

  def manager_staffing
    @presift = ManagerDemo.staffing_presift
    @cut = ManagerDemo.staffing_cut
  end

  def manager_performance
    @performance_rows = ManagerDemo.performance_rows
  end

  def manager_guests
    @guests = ManagerDemo.guests
  end

  def manager_no_shows
    @no_shows = ManagerDemo.no_shows
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
