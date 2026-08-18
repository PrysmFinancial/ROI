class Host::RushController < Host::BaseController
  MANAGER_RETURN = "/manager"
  HOST_FLOOR_RETURN = "/host/floor"

  def update
    Host::ToggleRush.call(shift: current_shift, enabled: params[:rush_mode])
    state = current_shift.rush_mode? ? "on" : "off"
    redirect_to after_rush_path, notice: "Rush mode #{state}."
  end

  private

  def after_rush_path
    requested = params[:return_to].to_s
    return requested if requested.in?([ MANAGER_RETURN, HOST_FLOOR_RETURN ])

    host_floor_path
  end
end
