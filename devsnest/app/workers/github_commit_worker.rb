# frozen_string_literal: true

# Worker to Perform Commit on Github
class GithubCommitWorker
  include Sidekiq::Worker

  def perform(user_id, repo, secrets, commited_files, commit_message)
    user = User.find_by_id(user_id)
    JSON.parse(secrets).each do |secret_name, secret_value|
      user.update_github_secret(repo, secret_name, secret_value)
    end
    user.create_github_commit(JSON.parse(commited_files), repo, commit_message)
  end
end
