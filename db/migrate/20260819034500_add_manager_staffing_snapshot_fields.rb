class AddManagerStaffingSnapshotFields < ActiveRecord::Migration[8.1]
  def change
    add_column :shifts, :staffing_forecast_covers, :integer, default: 0, null: false
    add_column :shifts, :staffing_plan_body, :text, default: "", null: false
  end
end
