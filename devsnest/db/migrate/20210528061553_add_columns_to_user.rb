class AddColumnsToUser < ActiveRecord::Migration[6.0]
    def change
      add_column :users, :github_url, :string
      add_column :users, :linkedin_url, :string
      add_column :users, :resume_url, :string
      add_column :users, :dob, :date
    end
  end