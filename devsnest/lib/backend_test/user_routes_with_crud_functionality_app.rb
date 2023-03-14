# frozen_string_literal: true

# backend challenge testcases
module BackendTest
  def self.run(url)
    UserCRUDApp.new(url).generate_result
  end

  # test for user crud api
  class UserCRUDApp
    def initialize(url)
      @url = url
      @user = {
        name: SecureRandom.hex(4),
        email: "#{SecureRandom.hex(4)}@gmail.com",
        password: SecureRandom.hex(4),
        age: rand(18..60)
      }.with_indifferent_access
      @success = []
      @failed = []
      @headers = {
        'Content-Type' => 'application/json'
      }
    end

    def generate_result
      should_register_user
      should_not_register_a_user_if_name_is_not_provided
      should_not_register_a_user_if_email_is_not_provided
      should_not_register_a_user_if_password_is_not_provided
      should_not_register_a_user_if_age_is_not_provided
      should_login_user_with_correct_credentials
      should_not_login_user_with_incorrect_credentials
      should_get_details_of_logged_in_user
      should_not_get_details_when_user_is_unauthorized
      should_logout_user_when_user_is_authorized
      should_not_logout_user_when_user_is_unauthorized

      {
        success: @success,
        failed: @failed,
        status: @failed.count.zero?,
        total_test_cases: @success.count + @failed.count
      }
    end

    private

    def should_register_user
      body = @user
      response = HTTParty.post("#{@url}/user/register", headers: @headers, body: body.to_json, timeout: 5)
      message = 'POST - should create a new User'
      response_body = verify_content_type(response)

      if response.code == 201 && response_body.is_a?(Hash) && response_body[:name] == body[:name] && response_body[:email] == body[:email] && response_body[:password].present? &&
         response_body[:id].present?
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_not_register_a_user_if_name_is_not_provided
      body =  {
        email: "#{SecureRandom.hex(4)}@gmail.com",
        password: SecureRandom.hex(4),
        age: rand(18..60)
      }
      response = HTTParty.post("#{@url}/user/register", headers: @headers, body: body.to_json, timeout: 5)
      message = 'POST - should not create a new User if name is not provided'
      if response.code == 400
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_not_register_a_user_if_email_is_not_provided
      body = {
        name: SecureRandom.hex(4),
        password: SecureRandom.hex(4),
        age: rand(18..60)
      }
      response = HTTParty.post("#{@url}/user/register", headers: @headers, body: body.to_json, timeout: 5)
      message = 'POST - should not create a new User if email is not provided'
      if response.code == 400
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_not_register_a_user_if_password_is_not_provided
      body =  {
        email: "#{SecureRandom.hex(4)}@gmail.com",
        name: SecureRandom.hex(4),
        age: rand(18..60)
      }
      response = HTTParty.post("#{@url}/user/register", headers: @headers, body: body.to_json, timeout: 5)
      message = 'POST - should not create a new User if password is not provided'
      if response.code == 400
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_not_register_a_user_if_age_is_not_provided
      body =  {
        email: "#{SecureRandom.hex(4)}@gmail.com",
        name: SecureRandom.hex(4),
        password: SecureRandom.hex(4)
      }
      response = HTTParty.post("#{@url}/user/register", headers: @headers, body: body.to_json, timeout: 5)
      message = 'POST - should not create a new User if age is not provided'
      if response.code == 400
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_login_user_with_correct_credentials
      body = {
        email: @user[:email],
        password: @user[:password]
      }
      response = HTTParty.post("#{@url}/user/login", headers: @headers, body: body.to_json, timeout: 5)
      message = 'POST - should login user with correct credentials'
      response_body = verify_content_type(response)
      if response.code == 200 && response_body.is_a?(Hash) && response_body[:token].present?
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_not_login_user_with_incorrect_credentials
      body = {
        email: @user[:email],
        password: SecureRandom.hex
      }
      response = HTTParty.post("#{@url}/user/login", headers: @headers, body: body.to_json, timeout: 5)
      message = 'POST - should not login user with incorrect credentials'
      response_body = verify_content_type(response)
      if response.code == 200 && response_body.is_a?(Hash) && response_body[:token].present?
        @user_token = response_body[:token]
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_get_details_of_logged_in_user
      headers = {
        Authorization: "Bearer #{@user_token}"
      }
      response = HTTParty.get("#{@url}/user/me", headers: headers, timeout: 5)
      message = 'GET - should get details of an authorized user'
      response_body = verify_content_type(response)
      if response.code == 200 && response_body.is_a?(Hash) && response_body[:email] == @user[:email] && response_body[:name] == @user[:name] && response_body[:age] == @user[:age]
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_not_get_details_when_user_is_unauthorized
      headers = {
        Authorization: 'Bearer 123'
      }
      response = HTTParty.get("#{@url}/user/me", headers: headers, timeout: 5)
      message = 'GET - should not get details of an unauthorized user'
      if response.code == 401
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_logout_user_when_user_is_authorized
      headers = {
        Authorization: "Bearer #{@user_token}"
      }
      response = HTTParty.post("#{@url}/user/logout", headers: headers, timeout: 5)
      message = 'POST - should logout user when user is authorized'
      if response.code == 200
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_not_logout_user_when_user_is_unauthorized
      headers = {
        Authorization: 'Bearer 12345'
      }
      response = HTTParty.post("#{@url}/user/logout", headers: headers, timeout: 5)
      message = 'POST - should not logout user when user is unauthorized'
      if response.code == 200
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
