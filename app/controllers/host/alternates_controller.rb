class Host::AlternatesController < Host::BaseController
  def create
    party = current_shift.parties.find(params[:id])
    table_id, server_shift_id = parse_pairing
    table = DiningTable.joins(:section).find_by!(sections: { shift_id: current_shift.id }, id: table_id)
    server_shift = current_shift.server_shifts.find(server_shift_id)

    Host::OfferAlternate.call(
      party:,
      dining_table: table,
      server_shift:,
      reason: params[:override_reason]
    )
    redirect_to host_floor_path, notice: "#{party.name} seated with alternate."
  rescue Host::OfferAlternate::HoldActiveError
    redirect_to host_floor_path, alert: "Pacing hold is active — wait or clear the hold first."
  rescue Host::OfferAlternate::ReasonRequiredError
    redirect_to host_floor_path, alert: "A reason is required to offer an alternate."
  rescue Host::OfferAlternate::InvalidAlternateError, Host::OfferAlternate::MissingRecommendationError => e
    redirect_to host_floor_path, alert: e.message
  rescue ActiveRecord::RecordNotFound
    redirect_to host_floor_path, alert: "Select a valid alternate."
  end

  private

  def parse_pairing
    raw = params[:pairing].presence || "#{params[:dining_table_id]}:#{params[:server_shift_id]}"
    table_id, server_shift_id = raw.to_s.split(":", 2)
    raise ActiveRecord::RecordNotFound if table_id.blank? || server_shift_id.blank?

    [ table_id, server_shift_id ]
  end
end
