class Host::SectionsController < Host::BaseController
  def approve_all
    Host::ApproveSections.call(shift: current_shift)
    redirect_to host_path, notice: "Section assignments approved."
  end
end
