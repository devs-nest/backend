class AddAndDeleteColumnFromChallenge < ActiveRecord::Migration[6.0]
  def change
    remove_column :challenges, :created_by, :integer
    add_column :challenges, :user_id, :integer
  end
end
