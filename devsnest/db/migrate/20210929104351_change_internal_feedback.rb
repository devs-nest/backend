class ChangeInternalFeedback < ActiveRecord::Migration[6.0]
  def change
    rename_column :internal_feedbacks, :issue_described, :issue_details
    rename_column :internal_feedbacks, :issue_type, :problems_faced
    rename_column :internal_feedbacks, :feedback, :solution
    add_column :internal_feedbacks, :feedback_type, :string
    add_column :internal_feedbacks, :group_activity_rating, :integer
    add_column :internal_feedbacks, :TL_rating, :integer
    add_column :internal_feedbacks, :VTL_rating, :string
    add_column :internal_feedbacks, :group_morale, :text
    add_column :internal_feedbacks, :obstacles_faced, :text
    add_column :internal_feedbacks, :BL_availability, :string
    add_column :internal_feedbacks, :BL_rating, :integer
    add_column :internal_feedbacks, :comments_on_BL, :text
  end
end
