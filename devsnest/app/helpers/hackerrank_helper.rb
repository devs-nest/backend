module HackerrankHelper
  class HackerrankUser
    def initialize(username = nil)
      raise "Username is required" if username.nil?

      @username = username
      @headers = {"User-Agent": "Rails"}
      @url = URI.encode("https://www.hackerrank.com/rest/contests/master/hackers/#{username}/profile")
      @heatmap_url = URI.encode("https://www.hackerrank.com/rest/hackers/#{username}/submission_histories")
      @certificates_url = URI.encode("https://www.hackerrank.com/community/v1/test_results/hacker_certificate?username=#{username}")
      @badges_url = URI.encode("https://www.hackerrank.com/rest/hackers/#{username}/badges")
    end

    def profile
      get_profile_api.delete("model")
    end

    def get_profile_api
      JSON.parse(HTTParty.get(@url, headers: @headers).body)
    end
    
    def certificates
      JSON.parse(HTTParty.get(@certificates_url, headers: @headers).body)
    end

    def badges
      JSON.parse(HTTParty.get(@badges_url, headers: @headers).body)
    end

    def heatmap
      JSON.parse(HTTParty.get(@heatmap_url, headers: @headers).body)
    end
  end
end