class AddGithubReposToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :github_repos, :text
  end
end
