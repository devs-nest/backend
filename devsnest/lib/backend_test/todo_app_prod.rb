# frozen_string_literal: true

# backend challenge testcases
module BackendTest
  def self.run(url)
    TodoAppProd.new(url).generate_result
  end

  # test for todo list prod api
  class TodoAppProd
    def initialize(url)
      @url = url
      @success = []
      @failed = []
      @todo = {
        title: SecureRandom.hex(3),
        description: SecureRandom.hex(3),
        completed: false,
        priority: rand(1..5),
        dueDate: Date.today + rand(1..4)
      }.with_indifferent_access
      @headers = {
        'Content-Type' => 'application/json'
      }
    end

    def generate_result
      create_a_new_todo
      should_not_create_a_todo_if_title_is_not_provided
      should_return_all_the_todos
      should_return_the_todo_when_id_is_provided
      should_not_return_the_notice_when_it_is_not_found_with_id
      should_update_the_todo
      should_delete_a_todo

      {
        success: @success,
        failed: @failed,
        status: @failed.count.zero?,
        total_test_cases: @success.count + @failed.count
      }
    end

    private

    def create_a_new_todo
      body = @todo
      response = HTTParty.post("#{@url}/api/todo", headers: @headers, body: body.to_json, timeout: 5)
      message = 'POST - should create a new Todo'
      response_body = verify_content_type(response)

      if response.code == 201 && response_body.is_a?(Hash) && response_body[:title] == @todo[:title] && response_body[:description] == @todo[:description] &&
         response_body[:completed] == @todo[:completed] && response_body[:priority] == @todo[:priority] && response_body[:dueDate].present? && response_body[:id].present?
        @todo_id = response_body[:id]
        @success << message
      else
        @failed << message
      end
    rescue Net::ReadTimeout
      @failed << message
    end

    def should_not_create_a_todo_if_title_is_not_provided
      body = {
        description: SecureRandom.hex(3),
        completed: false,
        priority: rand(1..5),
        dueDate: Date.today + rand(1..4)
      }.with_indifferent_access
      response = HTTParty.post("#{@url}/api/todo", headers: @headers, body: body.to_json, timeout: 5)
      message = 'POST - Should not create a new todo if title is not provided'

      if response.code == 400
        @success << message
      else
        @failed << message
      end
    rescue Net::ReadTimeout
      @failed << message
    end

    def should_return_all_the_todos
      response = HTTParty.get("#{@url}/api/todos", headers: @headers, timeout: 5)
      message = 'GET - should return all the todos'
      response_body = verify_content_type(response)

      if response.code == 200 && response_body.is_a?(Array) && response_body.count.positive?
        @success << message
      else
        @failed << message
      end
    rescue Net::ReadTimeout
      @failed << message
    end

    def should_return_the_todo_when_id_is_provided
      response = HTTParty.get("#{@url}/api/todo/#{@todo_id}", headers: @headers, timeout: 5)
      message = 'GET - should return the Todo when id is provided'
      response_body = verify_content_type(response)

      if response.code == 200 && response_body.is_a?(Hash) && response_body[:title] == @todo[:title] && response_body[:description] == @todo[:description] &&
         response_body[:completed] == @todo[:completed] && response_body[:priority] == @todo[:priority] && response_body[:dueDate].present? && response_body[:id].present?
        @success << message
      else
        @failed << message
      end
    rescue Net::ReadTimeout
      @failed << message
    end

    def should_not_return_the_notice_when_it_is_not_found_with_id
      id = 0
      response = HTTParty.get("#{@url}/api/notice/#{id}", headers: @headers, timeout: 5)
      message = 'GET - should not return the todo with id provided if it is not found'

      if response.code == 404
        @success << message
      else
        @failed << message
      end
    rescue Net::ReadTimeout
      @failed << message
    end

    def should_update_the_todo
      body = {
        title: SecureRandom.hex(3),
        description: SecureRandom.hex(3),
        completed: true,
        priority: rand(1..5),
        dueDate: Date.today + rand(1..4)
      }.with_indifferent_access
      response = HTTParty.put("#{@url}/api/todo/#{@todo_id}", headers: @headers, body: body.to_json, timeout: 5)
      message = 'PUT - should update the Todo'
      response_body = verify_content_type(response)

      if response.code == 200 && response_body.is_a?(Hash) && response_body[:title] == body[:title] && response_body[:description] == body[:description] &&
         response_body[:completed] == body[:completed] && response_body[:priority] == body[:priority] && response_body[:dueDate].present?
        @success << message
      else
        @failed << message
      end
    rescue Net::ReadTimeout
      @failed << message
    end

    def should_delete_a_todo
      response = HTTParty.delete("#{@url}/api/todo/#{@todo_id}", headers: @headers, timeout: 5)
      message = 'DELETE - should delete a Todo'

      if response.code == 200
        @success << message
      else
        @failed << message
      end
    end

    def should_not_delete_a_todo_if_not_found
      id = 0
      response = HTTParty.delete("#{@url}/api/todo/#{id}", headers: @headers, timeout: 5)
      message = 'DELETE - should not delete a Todo with id provided if it is not found'

      if response.code == 404
        @success << message
      else
        @failed << message
      end
    end

    def verify_content_type(response)
      JSON.parse(response.body, symbolize_names: true) if response.headers['Content-type'] == 'application/json; charset=utf-8'
    rescue StandardError
      nil
    end
  end
end
