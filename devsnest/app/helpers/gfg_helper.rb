module GfgHelper
  class GfgUser
    def initialize(username = nil)
      raise "Username is required" if username.nil?

      @username = username
      @url = "https://auth.geeksforgeeks.org/user/#{username}/"
      scraped_body
    end

    def scraped_body
      html = HTTParty.get(@url).response.body
      @doc = Nokogiri::HTML(html)

      raise "Invalid username" if @doc.css(".profile_name").blank?
    end

    def data
      {
        username: @username,
        institution_name: @doc.css(".basic_details_data")[0].content,
        institution_rank: @doc.css(".rankNum")[0].content,
        coding_score: @doc.css(".score_card_value")[0].content,
        problems_solved: @doc.css(".score_card_value")[1].content,
        monthly_coding_score: @doc.css(".score_card_value")[2].content,
        submissions: create_problem_solved_hash
      }
    end

    def create_problem_solved_hash
      @doc.css(".solved_problem_section > ul > li").map(&:content).map { |d| d.gsub(/([()])/, "") }.map { |d| d.split(" ") }.to_h
    end
  end
end