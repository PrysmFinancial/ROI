class AddHostP2Fields < ActiveRecord::Migration[8.1]
  def change
    add_column :shifts, :walk_in_forecast, :integer, default: 0, null: false
    add_column :shifts, :walk_in_forecast_detail, :string, default: "", null: false

    add_column :sections, :pickup_server_shift_id, :bigint
    add_index :sections, :pickup_server_shift_id
    add_foreign_key :sections, :server_shifts, column: :pickup_server_shift_id

    create_table :decision_events do |t|
      t.references :shift, null: false, foreign_key: true
      t.references :party, foreign_key: true
      t.string :kind, null: false
      t.string :summary, null: false
      t.text :detail, default: "", null: false
      t.timestamps
    end

    add_index :decision_events, [ :shift_id, :created_at ]
  end
end
