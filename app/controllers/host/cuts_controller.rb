class Host::CutsController < Host::BaseController
  MANAGER_STAFFING_RETURN = "/manager/staffing"

  def approve
    recommendation = current_shift.cut_recommendations.find(params[:id])
    Host::ApproveCut.call(recommendation:, pin: params[:pin])
    redirect_to after_cut_path, notice: "#{recommendation.server_shift.name} cut approved."
  rescue Host::ApproveCut::InvalidPinError
    redirect_to after_cut_path(cut: 1), alert: "Invalid manager code."
  end

  private

  def after_cut_path(extra = {})
    requested = params[:return_to].to_s
    return manager_staffing_path(extra) if requested == MANAGER_STAFFING_RETURN

    host_floor_path(extra)
  end
end
