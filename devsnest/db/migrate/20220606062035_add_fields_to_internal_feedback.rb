class AddFieldsToInternalFeedback < ActiveRecord::Migration[6.0]
  def change
    add_column :internal_feedbacks, :tl_vtl_feedback, :text
    add_column :internal_feedbacks, :most_helpful_teammate_id, :integer
  end
end
