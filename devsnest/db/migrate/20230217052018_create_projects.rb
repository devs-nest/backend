class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.integer :challenge_id
      t.string :challenge_type
      t.string :banner
      t.text :intro

      t.timestamps
    end

    add_column :be_submissions, :result, :text

    add_column :backend_challenges, :active_path, :string
    add_column :backend_challenges, :files, :text
    add_column :backend_challenges, :folder_name, :string
    add_column :backend_challenges, :hidden_files, :text
    add_column :backend_challenges, :open_paths, :text
    add_column :backend_challenges, :protected_paths, :text
    add_column :backend_challenges, :template, :string
    add_column :backend_challenges, :challenge_type, :integer, default: 0

    add_column :backend_challenges, :is_project, :boolean, default: false
    add_column :frontend_challenges, :is_project, :boolean, default: false
  end
end
