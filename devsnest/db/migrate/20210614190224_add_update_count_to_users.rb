class AddUpdateCountToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :update_count, :integer,default: 0
  end
end
