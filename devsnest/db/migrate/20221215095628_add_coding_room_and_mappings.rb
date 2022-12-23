class AddCodingRoomAndMappings < ActiveRecord::Migration[6.0]
  def change
    create_table :coding_rooms do |t|
      t.string :unique_id, default: SecureRandom.hex(6)
      t.string :name
      t.integer :room_time
      t.text :challenge_list
      t.boolean :is_private, default: false
      t.datetime :finish_at
      t.boolean :is_active, default: true
      t.boolean :has_started, default: false

      t.timestamps
    end

    add_index :coding_rooms, :unique_id
    add_index :coding_rooms, :is_active
    add_index :coding_rooms, :finish_at

    create_table :coding_room_user_mappings do |t|
      t.references :coding_room, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :has_left, default: false

      t.timestamps
    end

    add_index :coding_room_user_mappings, %i[coding_room_id user_id]
  end
end
