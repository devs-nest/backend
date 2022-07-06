class AddAssignmentSolvedInScrum < ActiveRecord::Migration[6.0]
  def change
    add_column :scrums, :total_assignments_solved, :json
    add_column :scrums, :recent_assignments_solved, :json
  end
end
