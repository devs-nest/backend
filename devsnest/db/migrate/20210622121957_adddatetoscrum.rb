class Adddatetoscrum < ActiveRecord::Migration[6.0]
  def change
    add_column :scrums, :date, :date, :default => Date.current
    add_index :scrums, [:user_id, :date], unique: true
  end
end
