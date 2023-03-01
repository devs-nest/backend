# frozen_string_literal: true

# backend challenge testcases
module BackendTest
  def self.run(url)
    URLParserAPp.new(url).generate_result
  end

  # test for URL Parser API
  class URLParserAPp
    def initialize(url)
      @url = url
      @success = []
      @failed = []
      @url_schema = {
        URL: 'https://www.devsnest.in/backend-challenges/url-parser/23'
      }.with_indifferent_access
      @headers = {
        'Content-Type' => 'application/json'
      }
    end

    def generate_result
      create_a_new_url
      should_not_create_a_new_url_if_name_is_not_present
      should_return_all_the_urls
      should_return_the_url_when_id_is_provided
      should_not_return_url_when_the_url_is_not_found_with_given_id
      should_update_the_url
      should_delete_the_url
      should_not_update_the_url_if_it_is_not_found
      should_not_delete_the_url_if_it_is_not_found_with_given_id

      {
        success: @success,
        failed: @failed,
        status: @failed.count.zero?,
        total_test_cases: @success.count + @failed.count
      }
    end

    private

    def create_a_new_url
      url_schema = @url_schema
      response = HTTParty.post("#{@url}/api/v1/url/add", headers: @headers, body: url_schema.to_json, timeout: 5)
      message = 'POST - should create a new URL'
      response_body = verify_content_type(response)

      if response.code == 201 && response_body.is_a?(Hash) && response_body[:URL] == url_schema[:URL] && response_body[:id].present?
        @url_id = response_body[:id]
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_not_create_a_new_url_if_name_is_not_present
      response = HTTParty.post("#{@url}/api/v1/url/add", headers: @headers, body: {}.to_json, timeout: 5)
      message = 'POST - should not create a new URL if name is not present'

      if response.code == 400
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_return_all_the_urls
      response = HTTParty.get("#{@url}/api/v1/url", headers: @headers, timeout: 5)
      message = 'GET - should return all the URLs'
      response_body = verify_content_type(response)

      if response.code == 200 && response_body.is_a?(Array) && response_body.count.positive?
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_return_the_url_when_id_is_provided
      response = HTTParty.get("#{@url}/api/v1/url/#{@url_id}", headers: @headers, timeout: 5)
      message = 'GET - should return the URL when id is provided'
      response_body = verify_content_type(response)

      if response.code == 200 && response_body.is_a?(Hash)
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_not_return_url_when_the_url_is_not_found_with_given_id
      id = 0
      response = HTTParty.get("#{@url}/api/v1/url/#{id}", headers: @headers, timeout: 5)
      message = 'GET - should not return the URL when the URL is not found with the given id'

      if response.code == 404
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_update_the_url
      body = {
        URL: 'https://www.devsnest.in/backend-challenges/url-parser/24'
      }.with_indifferent_access
      response = HTTParty.put("#{@url}/api/v1/url/#{@url_id}", headers: @headers, body: body.to_json, timeout: 5)
      message = 'PUT - should update the URL'
      response_body = verify_content_type(response)

      if response.code == 200 && response_body.is_a?(Hash) && response_body[:URL] == body[:URL] && response_body[:id] == @url_id
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_delete_the_url
      response = HTTParty.delete("#{@url}/api/v1/url/#{@url_id}", headers: @headers, timeout: 5)
      message = 'DELETE - should delete the URL'

      if response.code == 200
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_not_update_the_url_if_it_is_not_found
      body = {
        name: SecureRandom.hex(3)
      }.with_indifferent_access
      response = HTTParty.put("#{@url}/api/v1/url/#{@url_id}", headers: @headers, body: body.to_json, timeout: 5)
      message = 'PUT - should not update the URL if it is not found with given id'

      if response.code == 404
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_not_delete_the_url_if_it_is_not_found_with_given_id
      response = HTTParty.delete("#{@url}/api/v1/url/#{@url_id}", headers: @headers, timeout: 5)
      message = 'DELETE - should not delete the URL if it it not found with given id'

      if response.code == 404
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def verify_content_type(response)
      JSON.parse(response.body, symbolize_names: true) if response.headers['Content-type'] == 'application/json; charset=utf-8'
    rescue StandardError
      nil
    end
  end
end
