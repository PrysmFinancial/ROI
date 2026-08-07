class Host::SectionsController < Host::BaseController
  def approve_all
    Host::ApproveSections.call(shift: current_shift)
    redirect_to host_path, notice: "Section assignments approved."
  end

  def adjust
    section = current_shift.sections.find(params[:id])
    server_shift = current_shift.server_shifts.find(params[:server_shift_id])
    Host::AdjustSection.call(section:, server_shift:)
    redirect_to host_path, notice: "#{section.name} assigned to #{server_shift.name}."
  rescue Host::AdjustSection::InvalidServerError => e
    redirect_to host_path, alert: e.message
  end
end
