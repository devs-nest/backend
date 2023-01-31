# frozen_string_literal: true

# backend challenge testcases
module BackendTest
  def self.run(url)
    BookStoreApp.new(url).generate_result
  end

  # test for book store api
  class BookStoreApp
    def initialize(url)
      @url = url
      @success = []
      @failed = []
      @book = {
        name: SecureRandom.hex(3),
        author: SecureRandom.hex(3),
        genre: SecureRandom.hex(3),
        dateOfRelease: Date.today - rand(1000..2000),
        bookImage: SecureRandom.hex(3),
        rating: rand(1..10),
        price: rand(1..100)
      }.with_indifferent_access
      @headers = {
        'Content-Type' => 'application/json'
      }
    end

    def generate_result
      create_a_new_book
      should_not_create_a_new_book_if_name_is_not_present
      should_not_create_a_new_book_if_author_is_not_present
      should_not_create_a_new_book_if_genre_is_not_present
      should_not_create_a_new_book_if_dateOfRelease_is_not_present
      should_not_create_a_new_book_if_bookImage_is_not_present
      should_not_create_a_new_book_if_rating_is_not_present
      should_not_create_a_new_book_if_price_is_not_present
      should_return_all_the_books
      should_return_the_book_when_id_is_provided
      should_not_return_book_when_the_book_is_not_found_with_given_id
      should_update_the_book
      should_delete_the_book
      should_not_update_the_book_if_it_is_not_found
      should_not_delete_the_book_if_it_is_not_found_with_given_id

      {
        success: @success,
        failed: @failed,
        status: @failed.count.zero?,
        total_test_cases: @success.count + @failed.count
      }
    end

    private

    def create_a_new_book
      body = @book
      response = HTTParty.post("#{@url}/api/v1/books/add", headers: @headers, body: body.to_json, timeout: 5)
      message = 'POST - should create a new Book'
      response_body = verify_content_type(response)

      if response.code == 201 && response_body.is_a?(Hash) && response_body[:name] == @book[:name] && response_body[:author] == @book[:author] && response_body[:genre] == @book[:genre] &&
         response_body[:bookImage] == @book[:bookImage] && response_body[:rating] == @book[:rating] && response_body[:price] == @book[:price] && response_body[:id].present? &&
         response_body[:dateOfRelease].present?
        @book_id = response_body[:id]
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_not_create_a_new_book_if_name_is_not_present
      body = {
        author: SecureRandom.hex(3),
        genre: SecureRandom.hex(3),
        dateOfRelease: Date.today - rand(100..200),
        bookImage: SecureRandom.hex(3),
        rating: rand(1..10),
        price: rand(1..100)
      }.with_indifferent_access
      response = HTTParty.post("#{@url}/api/v1/books/add", headers: @headers, body: body.to_json, timeout: 5)
      message = 'POST - should not create a new Book if name is not present'

      if response.code == 400
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_not_create_a_new_book_if_author_is_not_present
      body = {
        name: SecureRandom.hex(3),
        genre: SecureRandom.hex(3),
        dateOfRelease: Date.today - rand(100..200),
        bookImage: SecureRandom.hex(3),
        rating: rand(1..10),
        price: rand(1..100)
      }.with_indifferent_access
      response = HTTParty.post("#{@url}/api/v1/books/add", headers: @headers, body: body.to_json, timeout: 5)
      message = 'POST - should not create a new Book if author is not present'

      if response.code == 400
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_not_create_a_new_book_if_genre_is_not_present
      body = {
        name: SecureRandom.hex(3),
        author: SecureRandom.hex(3),
        dateOfRelease: Date.today - rand(100..200),
        bookImage: SecureRandom.hex(3),
        rating: rand(1..10),
        price: rand(1..100)
      }.with_indifferent_access
      response = HTTParty.post("#{@url}/api/v1/books/add", headers: @headers, body: body.to_json, timeout: 5)
      message = 'POST - should not create a new Book if genre is not present'

      if response.code == 400
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_not_create_a_new_book_if_dateOfRelease_is_not_present
      body = {
        name: SecureRandom.hex(3),
        author: SecureRandom.hex(3),
        genre: SecureRandom.hex(3),
        bookImage: SecureRandom.hex(3),
        rating: rand(1..10),
        price: rand(1..100)
      }.with_indifferent_access
      response = HTTParty.post("#{@url}/api/v1/books/add", headers: @headers, body: body.to_json, timeout: 5)
      message = 'POST - should not create a new Book if dateOfRelease is not present'

      if response.code == 400
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_not_create_a_new_book_if_bookImage_is_not_present
      body = {
        name: SecureRandom.hex(3),
        author: SecureRandom.hex(3),
        genre: SecureRandom.hex(3),
        dateOfRelease: Date.today - rand(100..200),
        rating: rand(1..10),
        price: rand(1..100)
      }.with_indifferent_access
      response = HTTParty.post("#{@url}/api/v1/books/add", headers: @headers, body: body.to_json, timeout: 5)
      message = 'POST - should not create a new Book if bookImage is not present'

      if response.code == 400
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_not_create_a_new_book_if_rating_is_not_present
      body = {
        name: SecureRandom.hex(3),
        author: SecureRandom.hex(3),
        genre: SecureRandom.hex(3),
        dateOfRelease: Date.today - rand(100..200),
        bookImage: SecureRandom.hex(3),
        price: rand(1..100)
      }.with_indifferent_access
      response = HTTParty.post("#{@url}/api/v1/books/add", headers: @headers, body: body.to_json, timeout: 5)
      message = 'POST - should not create a new Book if rating is not present'

      if response.code == 400
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_not_create_a_new_book_if_price_is_not_present
      body = {
        name: SecureRandom.hex(3),
        author: SecureRandom.hex(3),
        genre: SecureRandom.hex(3),
        dateOfRelease: Date.today - rand(100..200),
        bookImage: SecureRandom.hex(3),
        rating: rand(1..10)
      }.with_indifferent_access
      response = HTTParty.post("#{@url}/api/v1/books/add", headers: @headers, body: body.to_json, timeout: 5)
      message = 'POST - should not create a new Book if price is not present'

      if response.code == 400
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_return_all_the_books
      response = HTTParty.get("#{@url}/api/v1/books", headers: @headers, timeout: 5)
      message = 'GET - should return all the books'
      response_body = verify_content_type(response)

      if response.code == 200 && response_body.is_a?(Array) && response_body.count.positive?
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_return_the_book_when_id_is_provided
      response = HTTParty.get("#{@url}/api/v1/books/#{@book_id}", headers: @headers, timeout: 5)
      message = 'GET - should return the book when id is provided'
      response_body = verify_content_type(response)

      if response.code == 200 && response_body.is_a?(Hash)
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_not_return_book_when_the_book_is_not_found_with_given_id
      id = 0
      response = HTTParty.get("#{@url}/api/v1/books/#{id}", headers: @headers, timeout: 5)
      message = 'GET - should not return the book when the book is not found with the given id'

      if response.code == 404
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_update_the_book
      body = {
        name: SecureRandom.hex(3),
        author: SecureRandom.hex(3),
        genre: SecureRandom.hex(3),
        dateOfRelease: Date.today - rand(100..200),
        bookImage: SecureRandom.hex(3),
        rating: rand(1..10),
        price: rand(1..100)
      }.with_indifferent_access
      response = HTTParty.put("#{@url}/api/v1/books/#{@book_id}", headers: @headers, body: body.to_json, timeout: 5)
      message = 'PUT - should update the Book'
      response_body = verify_content_type(response)

      if response.code == 200 && response_body.is_a?(Hash) && response_body[:name] == body[:name] && response_body[:author] == body[:author] && response_body[:genre] == body[:genre] &&
         response_body[:bookImage] == body[:bookImage] && response_body[:rating] == body[:rating] && response_body[:price] == body[:price] && response_body[:id].present? &&
         response_body[:dateOfRelease].present?
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_delete_the_book
      response = HTTParty.delete("#{@url}/api/v1/books/#{@book_id}", headers: @headers, timeout: 5)
      message = 'DELETE - should delete the Book'

      if response.code == 200
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_not_update_the_book_if_it_is_not_found
      body = {
        name: SecureRandom.hex(3)
      }.with_indifferent_access
      response = HTTParty.put("#{@url}/api/v1/books/#{@book_id}", headers: @headers, body: body.to_json, timeout: 5)
      message = 'PUT - should not update the Book if it is not found with given id'

      if response.code == 404
        @success << message
      else
        @failed << message
      end
    rescue StandardError
      @failed << message
    end

    def should_not_delete_the_book_if_it_is_not_found_with_given_id
      response = HTTParty.delete("#{@url}/api/v1/books/#{@book_id}", headers: @headers, timeout: 5)
      message = 'DELETE - should not delete the book if it it not found with given id'

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
