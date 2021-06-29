class AddUserIdToOnboards < ActiveRecord::Migration[6.0]
  def change
    add_column :onboards, :user_id, :integer
  end
end
