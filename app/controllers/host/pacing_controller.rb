class Host::PacingController < Host::BaseController
  def confirm
    decide!("confirmed")
  end

  def decline
    decide!("declined")
  end

  def clear_hold
    Host::ClearPacingHold.call(shift: current_shift)
    redirect_to host_floor_path, notice: "Pacing hold cleared."
  end

  private

  def decide!(decision)
    recommendation = current_shift.pacing_recommendations.find(params[:id])
    Host::DecidePacing.call(recommendation:, decision:)
    redirect_to host_floor_path, notice: "Pacing recommendation #{decision}."
  end
end
