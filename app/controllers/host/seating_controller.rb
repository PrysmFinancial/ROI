class Host::SeatingController < Host::BaseController
  def confirm
    party = current_shift.parties.find(params[:id])
    Host::ConfirmSeat.call(party:)
    redirect_to host_floor_path, notice: "#{party.name} seated."
  rescue Host::ConfirmSeat::HoldActiveError
    redirect_to host_floor_path, alert: "Pacing hold is active — wait or decline the hold first."
  rescue Host::ConfirmSeat::MissingRecommendationError
    redirect_to host_floor_path, alert: "No seating recommendation available."
  end
end
