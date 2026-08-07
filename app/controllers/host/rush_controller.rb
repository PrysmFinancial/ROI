class Host::RushController < Host::BaseController
  def update
    Host::ToggleRush.call(shift: current_shift, enabled: params[:rush_mode])
    state = current_shift.rush_mode? ? "on" : "off"
    redirect_to host_floor_path, notice: "Rush mode #{state}."
  end
end
