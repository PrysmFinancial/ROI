class Host::PickupsController < Host::BaseController
  def create
    table = DiningTable.joins(:section).find_by!(sections: { shift_id: current_shift.id }, id: params[:id])
    result = Host::ClearTableForPickup.call(dining_table: table)
    redirect_to host_floor_path,
                notice: "#{table.label} cleared → pickup #{result[:pickup].name}."
  rescue Host::ClearTableForPickup::NotSeatedError,
         Host::ClearTableForPickup::NotCutSectionError,
         Host::ClearTableForPickup::NoPickupServerError => e
    redirect_to host_floor_path, alert: e.message
  end
end
