class CreateMinibootcamp < ActiveRecord::Migration[6.0]
  def change
    create_table :minibootcamp do |t|
      t.string :unique_id, null: false
      t.string :parent_id
      t.integer :content_type, null: false
      t.timestamps
    end
  end
end
