class Host::CutsController < Host::BaseController
  def approve
    recommendation = current_shift.cut_recommendations.find(params[:id])
    Host::ApproveCut.call(recommendation:, pin: params[:pin])
    redirect_to host_floor_path, notice: "#{recommendation.server_shift.name} cut approved."
  rescue Host::ApproveCut::InvalidPinError
    redirect_to host_floor_path(cut: 1), alert: "Invalid manager code."
  end
end
