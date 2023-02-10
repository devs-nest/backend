class AddFilesToBackendChallenge < ActiveRecord::Migration[6.0]
  def change
    add_column :backend_challenges, :active_path, :string
    add_column :backend_challenges, :files, :text
    add_column :backend_challenges, :folder_name, :string
    add_column :backend_challenges, :hidden_files, :text
    add_column :backend_challenges, :open_paths, :text
    add_column :backend_challenges, :protected_paths, :text
    add_column :backend_challenges, :template, :string
    add_column :backend_challenges, :challenge_type, :integer, default: 0
  end
end
