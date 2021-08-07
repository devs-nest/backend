class AddUserNameToInternalFeedback < ActiveRecord::Migration[6.0]
  def change
    add_column :internal_feedbacks, :user_name, :string
  end
end
