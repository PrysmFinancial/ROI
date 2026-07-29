class CreateHostDomainModels < ActiveRecord::Migration[8.1]
  def change
    create_table :shifts do |t|
      t.date :service_date, null: false
      t.string :location_name, null: false, default: "The Hearth Room"
      t.boolean :rush_mode, null: false, default: false
      t.boolean :sections_approved, null: false, default: false
      t.datetime :sections_approved_at
      t.datetime :pacing_hold_until
      t.string :manager_pin, null: false, default: "1234"
      t.timestamps
    end
    add_index :shifts, :service_date

    create_table :servers do |t|
      t.string :name, null: false
      t.string :initial, null: false
      t.string :capability, null: false, default: "standard"
      t.decimal :baseline_covers_per_hour, precision: 5, scale: 1, null: false, default: 10.0
      t.timestamps
    end

    create_table :server_shifts do |t|
      t.references :shift, null: false, foreign_key: true
      t.references :server, null: false, foreign_key: true
      t.integer :start_order, null: false
      t.string :cut_status, null: false, default: "none"
      t.datetime :clocked_in_at
      t.integer :covers_tonight, null: false, default: 0
      t.decimal :covers_per_hour, precision: 5, scale: 1, null: false, default: 0.0
      t.timestamps
    end
    add_index :server_shifts, [ :shift_id, :server_id ], unique: true
    add_index :server_shifts, [ :shift_id, :start_order ]

    create_table :sections do |t|
      t.references :shift, null: false, foreign_key: true
      t.references :server_shift, foreign_key: true
      t.string :name, null: false
      t.integer :position, null: false, default: 0
      t.timestamps
    end
    add_index :sections, [ :shift_id, :name ], unique: true

    create_table :dining_tables do |t|
      t.references :section, null: false, foreign_key: true
      t.string :label, null: false
      t.integer :capacity, null: false
      t.string :status, null: false, default: "open"
      t.boolean :combinable, null: false, default: false
      t.datetime :seated_at
      t.timestamps
    end
    add_index :dining_tables, :label

    create_table :parties do |t|
      t.references :shift, null: false, foreign_key: true
      t.references :dining_table, foreign_key: true
      t.references :server_shift, foreign_key: true
      t.string :name, null: false
      t.integer :covers, null: false
      t.string :note, default: ""
      t.string :source, null: false, default: "reservation"
      t.time :reservation_time
      t.string :confirmation_status, null: false, default: "pending"
      t.string :lifecycle, null: false, default: "booked"
      t.integer :queue_position
      t.integer :quoted_wait_minutes
      t.string :tags, array: true, default: [], null: false
      t.timestamps
    end
    add_index :parties, [ :shift_id, :confirmation_status ]
    add_index :parties, [ :shift_id, :lifecycle ]

    create_table :seating_recommendations do |t|
      t.references :party, null: false, foreign_key: true
      t.references :dining_table, null: false, foreign_key: true
      t.references :server_shift, null: false, foreign_key: true
      t.string :summary, null: false
      t.string :status, null: false, default: "open"
      t.timestamps
    end

    create_table :pacing_recommendations do |t|
      t.references :shift, null: false, foreign_key: true
      t.string :message, null: false
      t.integer :hold_minutes, null: false, default: 10
      t.string :status, null: false, default: "open"
      t.datetime :decided_at
      t.timestamps
    end

    create_table :cut_recommendations do |t|
      t.references :shift, null: false, foreign_key: true
      t.references :server_shift, null: false, foreign_key: true
      t.string :reason, null: false
      t.string :status, null: false, default: "open"
      t.datetime :approved_at
      t.timestamps
    end
  end
end
