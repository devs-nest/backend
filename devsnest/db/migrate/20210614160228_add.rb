class Add < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :google_id, :string
  end
end
