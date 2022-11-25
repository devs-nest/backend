# frozen_string_literal: true

# backend challenge testcases
module BackendTest
  def self.run(url)
    test = TodoList.new(url)
    test.generate_result
  end

  # test for todo list rest api
  class TodoList
    def initialize(url)
      @url = url
      @uniq_username = SecureRandom.hex
      @password = SecureRandom.hex
      @auth_token = ''
      @task_id = ''
      @success = []
      @failed = []
    end

    def generate_result
      register_new_user
      should_not_create_a_new_user_if_email_is_already_registered
      should_not_register_a_new_user_if_email_is_not_provided
      should_not_register_a_new_user_if_username_is_not_provided
      should_not_register_a_new_user_if_password_is_not_provided
      should_login_user_if_correct_credentials_are_provided
      should_not_login_with_incorrect_password
      should_not_login_with_incorrect_email
      should_return_task_of_authenticated_user
      should_not_return_task_if_user_is_not_authenticated
      should_create_a_task
      should_not_create_a_task_if_user_is_not_authenticated
      should_not_create_a_task_if_title_is_not_provided
      should_update_the_completed
      should_not_update_the_task_if_user_is_not_authenticated
      should_not_delete_the_task_if_user_is_not_authenticated
      should_delete_the_task

      {
        success: @success,
        failed: @failed,
        status: @failed.count.zero?,
        total_test_cases: @success.count + @failed.count
      }
    end

    private

    def register_new_user
      body = {
        username: @uniq_username,
        email: "#{@uniq_username}_user1@gmail.com",
        password: @password
      }
      headers = {
        'Content-Type' => 'application/json'
      }
      response = HTTParty.post("#{@url}/user/signup", body: body.to_json, headers: headers, timeout: 1)

      if response.code == 200 && response.headers['Content-type'] == 'application/json; charset=utf-8' && JSON.parse(response.body, symbolize_names: true)[:title] == 'user created'
        @success << 'should register a new user'
      else
        @failed << 'should register a new user'
      end
    end

    def should_not_create_a_new_user_if_email_is_already_registered
      body = {
        username: @uniq_username,
        email: "#{@uniq_username}_user1@gmail.com",
        password: @password
      }
      headers = {
        'Content-Type' => 'application/json'
      }
      response = HTTParty.post("#{@url}/user/signup", body: body.to_json, headers: headers, timeout: 1)

      if response.code == 400 && response.headers['Content-type'] == 'application/json; charset=utf-8' && JSON.parse(response.body, symbolize_names: true)[:title] == 'error' && JSON.parse(response.body, symbolize_names: true)[:error] == 'email already in use'
        @success << 'should not create a new user if email is already registered'
      else
        @failed << 'should not create a new user if email is already registered'
      end
    end

    def should_not_register_a_new_user_if_email_is_not_provided
      body = {
        username: 'user1',
        password: @password
      }
      headers = {
        'Content-Type' => 'application/json'
      }
      response = HTTParty.post("#{@url}/user/signup", body: body.to_json, headers: headers, timeout: 1)
      if response.code == 400 && response.headers['Content-type'] == 'application/json; charset=utf-8'
        @success << 'should not register a new user if email is not provided'
      else
        @failed << 'should not register a new user if email is not provided'
      end
    end

    def should_not_register_a_new_user_if_username_is_not_provided
      body = {
        email: "#{SecureRandom.hex}_user1@gmail.com",
        password: @password
      }
      headers = {
        'Content-Type' => 'application/json'
      }

      response = HTTParty.post("#{@url}/user/signup", body: body.to_json, headers: headers, timeout: 1)
      if response.code == 400 && response.headers['Content-type'] == 'application/json; charset=utf-8'
        @success << 'should not register a new user if username is not provided'
      else
        @failed << 'should not register a new user if username is not provided'
      end
    end

    def should_not_register_a_new_user_if_password_is_not_provided
      uniq_user = SecureRandom.hex
      body = {
        username: uniq_user.to_s,
        email: "#{uniq_user}_user1@gmail.com"
      }
      headers = {
        'Content-Type' => 'application/json'
      }

      response = HTTParty.post("#{@url}/user/signup", body: body.to_json, headers: headers, timeout: 1)
      if response.code == 400 && response.headers['Content-type'] == 'application/json; charset=utf-8'
        @success << 'should not register a new user if password is not provided'
      else
        @failed << 'should not register a new user if password is not provided'
      end
    end

    def should_login_user_if_correct_credentials_are_provided
      body = {
        email: "#{@uniq_username}_user1@gmail.com",
        password: @password
      }
      headers = {
        'Content-Type' => 'application/json'
      }
      response = HTTParty.post("#{@url}/user/login", body: body.to_json, headers: headers, timeout: 1)
      if response.code == 200 && response.headers['Content-type'] == 'application/json; charset=utf-8' && JSON.parse(response.body, symbolize_names: true)[:title] == 'login success' && JSON.parse(response.body, symbolize_names: true)[:token].present?
        @auth_token = JSON.parse(response.body, symbolize_names: true)[:token]
        @success << 'should login user if correct credentials are provided'
      else
        @failed << 'should login user if correct credentials are provided'
      end
    end

    def should_not_login_with_incorrect_password
      body = {
        email: "#{@uniq_username}_user1@gmail.com",
        password: SecureRandom.hex
      }
      headers = {
        'Content-Type' => 'application/json'
      }
      response = HTTParty.post("#{@url}/user/login", body: body.to_json, headers: headers, timeout: 1)
      if response.headers['Content-type'] != 'application/json; charset=utf-8'
        @failed << 'should not login with incorrect password'
        return
      end

      response_body = JSON.parse(response.body, symbolize_names: true)
      if response.code == 401 && response_body[:title] == 'login failed' && response_body[:error] == 'invalid username or password'
        @success << 'should not login with incorrect password'
      else
        @failed << 'should not login with incorrect password'
      end
    end

    def should_not_login_with_incorrect_email
      body = {
        email: "#{SecureRandom.hex}_user1@gmail.com",
        password: @password
      }
      headers = {
        'Content-Type' => 'application/json'
      }
      response = HTTParty.post("#{@url}/user/login", body: body.to_json, headers: headers, timeout: 1)
      if response.code == 401 && response.headers['Content-type'] == 'application/json; charset=utf-8' && JSON.parse(response.body, symbolize_names: true)[:title] == 'user not found'
        @success << 'should not login with incorrect email'
      else
        @failed << 'should not login with incorrect email'
      end
    end

    def should_return_task_of_authenticated_user
      headers = {
        Authorization: "Bearer #{@auth_token}"
      }
      response = HTTParty.get("#{@url}/task", headers: headers, timeout: 1)
      if response.headers['Content-type'] != 'application/json; charset=utf-8'
        @failed << 'should return tasks of authenticated user'
        return
      end
      response_body = JSON.parse(response.body, symbolize_names: true)

      if response.code == 200 && response_body[:title] == 'success' && response_body[:todos].is_a?(Array) && response_body[:todos].count.zero?
        @success << 'should return tasks of authenticated user'
      else
        @failed << 'should return tasks of authenticated user'
      end
    end

    def should_not_return_task_if_user_is_not_authenticated
      headers = {
        Authorization: "Bearer #{SecureRandom.hex}"
      }
      response = HTTParty.get("#{@url}/task", headers: headers, timeout: 1)
      if response.code == 401 && response.headers['Content-type'] == 'application/json; charset=utf-8' && JSON.parse(response.body, symbolize_names: true)[:title] == 'not authenticated' && JSON.parse(response.body, symbolize_names: true)[:todos].nil?
        @success << 'should not return tasks if user is not authenticated'
      else
        @failed << 'should not return tasks if user is not authenticated'
      end
    end

    def should_create_a_task
      headers = {
        'Content-Type' => 'application/json',
        Authorization: "Bearer #{@auth_token}"
      }
      body = {
        title: 'Write RSpec for Users'
      }
      response = HTTParty.post("#{@url}/task", body: body.to_json, headers: headers, timeout: 1)
      if response.headers['Content-type'] != 'application/json; charset=utf-8'
        @failed << 'should create a task'
        return
      end
      response_body = JSON.parse(response.body, symbolize_names: true)
      if response.code == 200 && response_body[:title] == 'successfully added' && !response_body[:todo].nil? && response_body[:todo][:title] == 'Write RSpec for Users' && !response_body[:todo][:completed]
        @success << 'should create a task'
        @task_id = response_body[:todo][:_id]
      else
        @failed << 'should create a task'
      end
    end

    def should_not_create_a_task_if_user_is_not_authenticated
      headers = {
        'Content-Type' => 'application/json',
        Authorization: "Bearer #{SecureRandom.hex}"
      }
      body = {
        title: 'Write RSpec for Users'
      }
      response = HTTParty.post("#{@url}/task", body: body.to_json, headers: headers, timeout: 1)
      if response.headers['Content-type'] != 'application/json; charset=utf-8'
        @failed << 'should not create a task when user is not authorized'
        return
      end
      response_body = JSON.parse(response.body, symbolize_names: true)
      if response.code == 401 && response_body[:title] == 'not authenticated' && response_body[:todo].nil?
        @success << 'should not create a task when user is not authorized'
      else
        @failed << 'should not create a task when user is not authorized'
      end
    end

    def should_not_create_a_task_if_title_is_not_provided
      headers = {
        'Content-Type' => 'application/json',
        Authorization: "Bearer #{@auth_token}"
      }
      body = {
        completed: false
      }
      response = HTTParty.post("#{@url}/task", body: body.to_json, headers: headers, timeout: 1)
      if response.headers['Content-type'] != 'application/json; charset=utf-8'
        @failed << 'should not create a task if title is not provided'
        return
      end
      response_body = JSON.parse(response.body, symbolize_names: true)
      if response.code == 400 && response_body[:title] == 'error' && response_body[:todo].nil? && response_body[:error] == 'Todo validation failed: title: Path `title` is required.'
        @success << 'should not create a task if title is not provided'
      else
        @failed << 'should not create a task if title is not provided'
      end
    end

    def should_update_the_completed
      headers = {
        'Content-Type': 'application/json',
        Authorization: "Bearer #{@auth_token}"
      }
      body = {
        completed: true
      }
      response = HTTParty.put("#{@url}/task/#{@task_id}", body: body.to_json, headers: headers, timeout: 1)
      if response.headers['Content-type'] != 'application/json; charset=utf-8'
        @failed << 'should update the completed'
        return
      end
      response_body = JSON.parse(response.body, symbolize_names: true)
      if response.code == 200 && response_body[:title] == 'todo updated' && response_body[:todo][:completed] == true
        @success << 'should update the completed'
      else
        @failed << 'should update the completed'
      end
    end

    def should_not_update_the_task_if_user_is_not_authenticated
      headers = {
        'Content-Type': 'application/json'
      }
      body = {
        completed: false
      }
      response = HTTParty.put("#{@url}/task/#{@task_id}", body: body.to_json, headers: headers, timeout: 1)
      if response.code == 401 && response.headers['Content-type'] == 'application/json; charset=utf-8' && JSON.parse(response.body, symbolize_names: true)[:title] == 'not authenticated'
        @success << 'should not update the task if user is not authenticated'
      else
        @failed << 'should not update the task if user is not authenticated'
      end
    end

    def should_not_delete_the_task_if_user_is_not_authenticated
      response = HTTParty.delete("#{@url}/task/#{@task_id}", timeout: 1)
      if response.code == 401 && response.headers['Content-type'] == 'application/json; charset=utf-8' && JSON.parse(response.body, symbolize_names: true)[:title] == 'not authenticated'
        @success << 'should not delete the task if user is not authenticated'
      else
        @failed << 'should not delete the task if user is not authenticated'
      end
    end

    def should_delete_the_task
      headers = {
        Authorization: "Bearer #{@auth_token}"
      }
      response = HTTParty.delete("#{@url}/task/#{@task_id}", headers: headers, timeout: 1)
      if response.code == 200 && response.headers['Content-type'] == 'application/json; charset=utf-8' && JSON.parse(response.body, symbolize_names: true)[:title] == 'todo deleted'
        @success << 'should delete the task'
      else
        @failed << 'should delete the task'
      end
    end
  end
end
