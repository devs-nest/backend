module GfgHelper
  class GfgUser
    def initialize(username = nil)
      raise "Username is required" if username.nil?

      @username = username
      # @url = "https://leetcode.com/graphql"
      # @headers = { "content-type": "application/graphql" }
    end
  end
end