class AddIsProjectToBackendChallengeAndFrontendChallenge < ActiveRecord::Migration[6.0]
  def change
    add_column :backend_challenges, :is_project, :boolean, default: false
    add_column :frontend_challenges, :is_project, :boolean, default: false
  end
end
