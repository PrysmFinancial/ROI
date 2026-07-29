class AddManagersAndClearPacingHold < ActiveRecord::Migration[8.1]
  def change
    create_table :managers do |t|
      t.string :name, null: false
      t.string :pin, null: false
      t.boolean :active, null: false, default: true
      t.timestamps
    end
    add_index :managers, :pin, unique: true

    add_reference :cut_recommendations, :approved_by_manager, foreign_key: { to_table: :managers }

    remove_column :shifts, :manager_pin, :string, null: false, default: "1234"
  end
end
