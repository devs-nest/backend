# frozen_string_literal: true

# backend challenge testcases
module BackendTest
  def self.run(url)
    NoticeBoardApp.new(url).generate_result
  end

  # test for shopping cart api
  class NoticeBoardApp
    def initialize(url)
      @url = url
      @success = []
      @failed = []
      @notice = {
        author: SecureRandom.hex,
        message: SecureRandom.hex
      }
      @headers = {
        'Content-Type' => 'application/json'
      }
    end

    def generate_result
      create_a_new_notice
      should_not_create_a_notice_if_author_is_not_provided
      should_not_create_a_notice_if_message_is_not_provided
      should_return_all_the_notices
      should_return_the_notice_when_id_is_provided
      should_not_return_the_notice_when_it_is_not_found_with_id
      should_update_the_likes_count
      should_not_update_the_likes_count_if_notice_is_not_found

      {
        success: @success,
        failed: @failed,
        status: @failed.count.zero?,
        total_test_cases: @success.count + @failed.count
      }
    end

    private

    def create_a_new_notice
      body = @notice
      response = HTTParty.post("#{@url}/api/notice", headers: @headers, body: body.to_json, timeout: 5)
      message = 'POST - should create a new Notice'
      response_body = verify_content_type(response)

      if response_body.nil?
        @failed << message
      elsif response.code == 201 && response_body['author'] == body['author'] && response_body['message'] == body['message'] && response_body['likes'] == 0 && response_body['date'].present? && response_body['id'].present?
        @notice_id = response_body['id']
        @success << message
      end
    rescue Net::ReadTimeout
      @failed << message
    end

    def should_not_create_a_notice_if_author_is_not_provided
      body = {
        message: SecureRandom.hex
      }
      response = HTTParty.post("#{@url}/api/notice", headers: @headers, body: body.to_json, timeout: 5)
      message = 'POST - should not create a new Notice if author is not provided'
      response_body = verify_content_type(response)

      if response_body.nil?
        @failed << message
      elsif response.code == 400
        @success << message
      end
    rescue Net::ReadTimeout
      @failed << message
    end

    def should_not_create_a_notice_if_message_is_not_provided
      body = {
        author: SecureRandom.hex
      }
      response = HTTParty.post("#{@url}/api/notice", headers: @headers, body: body.to_json, timeout: 5)
      message = 'POST - should not create a new Notice if message is not provided'
      response_body = verify_content_type(response)

      if response_body.nil?
        @failed << message
      elsif response.code == 400
        @success << message
      end
    rescue Net::ReadTimeout
      @failed << message
    end

    def should_return_all_the_notices
      response = HTTParty.get("#{@url}/api/notice", headers: @headers, timeout: 5)
      message = 'GET - should return all the notices'
      response_body = verify_content_type(response)

      if response_body.nil?
        @failed << message
      elsif response.code == 200 && response_body['data'].is_a?(Array)
        @success << message
      end
    rescue Net::ReadTimeout
      @failed << message
    end

    def should_return_the_notice_when_id_is_provided
      response = HTTParty.get("#{@url}/api/notice/#{@notice_id}", headers: @headers, timeout: 5)
      message = 'GET - should return the notice when id is provided'
      response_body = verify_content_type(response)

      if response_body.nil?
        @failed << message
      elsif response.code == 200 && response_body['author'] == @notice['author'] && response_body['message'] == @notice['message'] && response_body['likes'].present? && response_body['date'].present? && response_body['id'].present?
        @success << message
      end
    rescue Net::ReadTimeout
      @failed << message
    end

    def should_not_return_the_notice_when_it_is_not_found_with_id
      id = 0
      response = HTTParty.get("#{@url}/api/notice/#{id}", headers: @headers, timeout: 5)
      message = 'GET - should not return the notice with id provided if it is not found'
      response_body = verify_content_type(response)

      if response_body.nil?
        @failed << message
      elsif response.code == 404
        @success << message
      end
    rescue Net::ReadTimeout
      @failed << message
    end

    def should_update_the_likes_count
      response = HTTParty.put("#{@url}/api/notice/#{@notice_id}/like", headers: @headers, timeout: 5)
      message = 'PUT - should increase the like count by 1'
      response_body = verify_content_type(response)

      if response_body.nil?
        @failed << message
      elsif response.code == 200 && response_body['author'] == @notice['author'] && response_body['message'] == @notice['message'] && response_body['likes'] == 1 && response_body['date'].present? && response_body['id'].present?
        @success << message
      end
    rescue Net::ReadTimeout
      @failed << message
    end

    def should_not_update_the_likes_count_if_notice_is_not_found
      id = 0
      response = HTTParty.put("#{@url}/api/notice/#{id}/like", headers: @headers, timeout: 5)
      message = 'PUT - should not increase the like count by 1 if notice is not found'
      response_body = verify_content_type(response)

      if response_body.nil?
        @failed << message
      elsif response.code == 404
        @success << message
      end
    rescue Net::ReadTimeout
      @failed << message
    end

    def verify_content_type(response)
      return JSON.parse(response.body, symbolize_names: true) if response.headers['Content-type'] == 'application/json; charset=utf-8'

      nil
    end
  end
end
