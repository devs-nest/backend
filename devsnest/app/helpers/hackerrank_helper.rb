module HackerrankHelper
  class HackerrankUser
    def initialize(username = nil)
      raise "Username is required" if username.nil?

      @username = username
      @headers = {"User-Agent": "Rails"}
      @url = "https://www.hackerrank.com/rest/contests/master/hackers/#{username}/profile"
      @heatmap_url = "https://www.hackerrank.com/rest/hackers/#{username}/submission_histories"
    end

    def profile
      get_profile_api.delete("model")
    end

    def get_profile_api
      JSON.parse(HTTParty.get(@url, headers: @headers).body)
    end

    def heatmap
      JSON.parse(HTTParty.get(@heatmap_url, headers: @headers).body)
    end
  end
end