class AddManagerShiftSnapshotFields < ActiveRecord::Migration[8.1]
  def change
    add_column :shifts, :net_sales, :integer, default: 0, null: false
    add_column :shifts, :avg_turn_minutes, :integer, default: 0, null: false
    add_column :shifts, :covers_vs_prior_pct, :integer, default: 0, null: false
    add_column :shifts, :turn_vs_prior_minutes, :integer, default: 0, null: false
    add_column :shifts, :kitchen_load_pct, :integer, default: 0, null: false
    add_column :shifts, :late_demand_label, :string, default: "", null: false
    add_column :shifts, :late_demand_pct, :integer, default: 0, null: false
  end
end
