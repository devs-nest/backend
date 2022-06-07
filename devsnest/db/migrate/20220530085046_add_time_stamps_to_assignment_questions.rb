class AddTimeStampsToAssignmentQuestions < ActiveRecord::Migration[6.0]
  def change
    change_table(:assignment_questions) { |t| t.timestamps }
  end
end
