class AddIsProjectAndBannerToBackendChallengeAndFrontendChallenge < ActiveRecord::Migration[6.0]
  def change
    add_column :backend_challenges, :is_project, :boolean, default: false
    add_column :backend_challenges, :banner, :string

    add_column :frontend_challenges, :is_project, :boolean, default: false
    add_column :frontend_challenges, :banner, :string
  end
end
