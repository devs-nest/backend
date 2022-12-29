# frozen_string_literal: true

# helper for getting users github data
module GithubDataHelper
  def self.get_github_graph(github_username, github_token)
    query = %{
      query($userName:String!) {
        user(login: $userName){
          contributionsCollection {
            contributionCalendar {
              totalContributions
              weeks {
                contributionDays {
                  contributionCount
                  date
                }
              }
            }
          }
        }
      }
    }
    variables = { userName: github_username }
    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{github_token}"
    }
    response = HTTParty.post('https://api.github.com/graphql', headers: headers, body: { query: query, variables: variables }.to_json).with_indifferent_access
    response[:data][:user][:contributionsCollection][:contributionCalendar]
  end

  def self.get_repository_data(github_username, github_repos)
    repository_data = []
    github_repos.each do |repo|
      response = HTTParty.get("https://api.github.com/repos/#{github_username}/#{repo}")
      next if response.code != 200

      repository_data << {
        name: response['name'],
        description: response['description'],
        html_url: response['html_url']
      }
    end
    repository_data
  end

  def self.does_repository_exists(github_username, repo_name)
    response = HTTParty.get("https://api.github.com/repos/#{github_username}/#{repo_name}")
    response.code == 200
  end
end
