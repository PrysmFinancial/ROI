class Host::SectionsController < Host::BaseController
  MANAGER_STAFFING_RETURN = "/manager/staffing"

  def approve_all
    Host::ApproveSections.call(shift: current_shift)
    redirect_to after_approve_sections_path, notice: "Section assignments approved."
  end

  def adjust
    section = current_shift.sections.find(params[:id])
    server_shift = current_shift.server_shifts.find(params[:server_shift_id])
    Host::AdjustSection.call(section:, server_shift:)
    redirect_to host_path, notice: "#{section.name} assigned to #{server_shift.name}."
  rescue Host::AdjustSection::InvalidServerError => e
    redirect_to host_path, alert: e.message
  end

  private

  def after_approve_sections_path
    requested = params[:return_to].to_s
    return requested if requested == MANAGER_STAFFING_RETURN

    host_path
  end
end
