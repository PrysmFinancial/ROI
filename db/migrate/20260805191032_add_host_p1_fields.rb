class AddHostP1Fields < ActiveRecord::Migration[8.1]
  def change
    add_column :parties, :rush_tagged, :boolean, default: false, null: false
    add_column :seating_recommendations, :override_reason, :string
  end
end
