# frozen_string_literal: true

# helper for getting users github data
module GithubDataHelper
  class GitHubData
    def initialize(username = nil, github_token = nil)
      raise "Username is required" if username.nil?
  
      @username = username
      @headers = {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{github_token}"
      }
    end
  
    def get_github_graph
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
      variables = { userName: @username }
      response = HTTParty.post('https://api.github.com/graphql', headers: @headers, body: { query: query, variables: variables }.to_json).with_indifferent_access
      response[:data][:user][:contributionsCollection][:contributionCalendar]
    end

    def get_github_profile
      query = %{
        query($userName:String!) {
          user(login: $userName){
            anyPinnableItems
            avatarUrl
            bio
            company
            email
            followers {
              totalCount
            }
            following {
              totalCount
            }
            pinnedItems(first: 6, types: REPOSITORY) {
              nodes {
                ... on Repository {
                  name
                  description
                  url
                  createdAt
                  updatedAt
                }
              }
            }
          }
        }
      }
      variables = { userName: @username }
      response = HTTParty.post('https://api.github.com/graphql', headers: @headers, body: { query: query, variables: variables }.to_json).with_indifferent_access
      response[:data][:user]
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
end
