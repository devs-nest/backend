# frozen_string_literal: true

# backend challenge testcases
module BackendTest
  def self.run(url)
    ShoppingCartApp.new(url).generate_result
  end

  # test for shopping cart api
  class ShoppingCartApp
    def initialize(url)
      @url = url
      @success = []
      @failed = []
      @product = {
        name: SecureRandom.hex,
        description: SecureRandom.hex,
        brand: SecureRandom.hex,
        cost: 10
      }
      @headers = {
        'Content-Type' => 'application/json'
      }
    end

    def generate_result
      should_create_a_new_product
      should_not_create_a_new_product_if_name_is_missing
      should_not_create_a_new_product_if_description_is_missing
      should_not_create_a_new_product_if_brand_is_missing
      should_not_create_a_new_product_if_cost_is_missing
      should_return_all_the_products
      should_return_product_with_id
      should_not_return_a_product_with_id_if_is_not_found
      should_update_a_product
      should_not_update_product_if_it_is_not_found
      should_delete_a_product
      should_not_delete_a_product_if_it_is_not_found

      {
        success: @success,
        failed: @failed,
        status: @failed.count.zero?,
        total_test_cases: @success.count + @failed.count
      }
    end

    private

    def should_create_a_new_product
      body = @product
      response = HTTParty.post("#{@url}/api/v1/products/add", body: body.to_json, headers: @headers, timeout: 5)
      message = 'POST - Create a new Product'
      response_body = verify_content_type(response)

      if response_body.nil?
        @failed << message
      elsif response.code == 201 && response_body['name'] == body['name'] && response_body['description'] == body['description'] && response_body['brand'] == body['brand'] && response_body['cost'] == body['cost'] && response_body['id'].present?
        @product_id = response_body['id']
        @success << message
      end
    rescue Net::ReadTimeout
      @failed << message
    end

    def should_not_create_a_new_product_if_name_is_missing
      body = {
        description: 'some description as well',
        brand: 'testing',
        cost: 10
      }
      response = HTTParty.post("#{@url}/api/v1/products/add", body: body.to_json, headers: @headers, timeout: 5)
      message = 'POST - Should not create a new Product if name is missing'
      response_body = verify_content_type(response)

      if response_body.nil?
        @failed << message
      elsif response.code == 400
        @success << message
      end
    rescue Net::ReadTimeout
      @failed << message
    end

    def should_not_create_a_new_product_if_description_is_missing
      body = {
        name: 'Product 1',
        brand: 'testing',
        cost: 10
      }
      response = HTTParty.post("#{@url}/api/v1/products/add", body: body.to_json, headers: @headers, timeout: 5)
      message = 'POST - Should not create a new Product if description is missing'
      response_body = verify_content_type(response)

      if response_body.nil?
        @failed << message
      elsif response.code == 400
        @success << message
      end
    rescue Net::ReadTimeout
      @failed << message
    end

    def should_not_create_a_new_product_if_brand_is_missing
      body = {
        name: 'Product 1',
        description: 'description 1',
        cost: 10
      }
      response = HTTParty.post("#{@url}/api/v1/products/add", body: body.to_json, headers: @headers, timeout: 5)
      message = 'POST - Should not create a new Product if brand is missing'
      response_body = verify_content_type(response)

      if response_body.nil?
        @failed << message
      elsif response.code == 400
        @success << message
      end
    rescue Net::ReadTimeout
      @failed << message
    end

    def should_not_create_a_new_product_if_cost_is_missing
      body = {
        name: 'Product 1',
        description: 'description 1',
        brand: 'brand 1'
      }
      response = HTTParty.post("#{@url}/api/v1/products/add", body: body.to_json, headers: @headers, timeout: 5)
      message = 'POST - Should not create a new Product if cost is missing'
      response_body = verify_content_type(response)

      if response_body.nil?
        @failed << message
      elsif response.code == 400
        @success << message
      end
    rescue Net::ReadTimeout
      @failed << message
    end

    def should_return_all_the_products
      response = HTTParty.get("#{@url}/api/v1/products", headers: @headers, timeout: 5)
      message = 'GET - should return all the products'
      response_body = verify_content_type(response)

      if response_body.nil?
        @failed << message
      elsif response.code == 200 && response_body['products'].is_a?(Array)
        @success << message
      end
    rescue Net::ReadTimeout
      @failed << message
    end

    def should_return_product_with_id
      response = HTTParty.get("#{@url}/api/v1/products/#{@product_id}", headers: @headers, timeout: 5)
      message = 'GET - should return the product when id is provided'
      response_body = verify_content_type(response)

      if response_body.nil?
        @failed << message
      elsif response.code == 200 && response_body['name'] == @product['name'] && response_body['description'] == @product['description'] && response_body['brand'] == @product['brand'] && response_body['cost'] == @product['cost']
        @success << message
      end
    rescue Net::ReadTimeout
      @failed << message
    end

    def should_not_return_a_product_with_id_if_is_not_found
      id = -100
      response = HTTParty.get("#{@url}/api/v1/products/#{id}", headers: @headers, timeout: 5)
      message = 'GET - should not return a product with id provided if it is not found'
      response_body = verify_content_type(response)

      if response_body.nil?
        @failed << message
      elsif response.code == 404 && !response_body['name'].present? && !response_body['description'].present? && !response_body['brand'].present? && !response_body['cost'].present?
        @success << message
      end
    rescue Net::ReadTimeout
      @failed << message
    end

    def should_update_a_product
      body = {
        name: SecureRandom.hex,
        description: SecureRandom.hex,
        brand: SecureRandom.hex,
        cost: 100
      }
      response = HTTParty.put("#{@url}/api/v1/products/#{@product_id}", headers: @headers, body: body.to_json, timeout: 5)
      response_body = verify_content_type(response)
      message = 'PUT - should update a product'

      if response_body.nil?
        @failed << message
      elsif response.code == 200 && response_body['name'] == body['name'] && response_body['description'] == body['description'] && response_body['brand'] == body['brand'] && response_body['cost'] == body['cost']
        @success << message
      end
    rescue Net::ReadTimeout
      @failed << message
    end

    def should_not_update_product_if_it_is_not_found
      id = -100
      body = {
        name: SecureRandom.hex,
        description: SecureRandom.hex,
        brand: SecureRandom.hex,
        cost: 100
      }
      response = HTTParty.put("#{@url}/api/v1/products/#{id}", headers: @headers, body: body.to_json, timeout: 5)
      response_body = verify_content_type(response)
      message = 'PUT - should not update a product if it is not found'

      if response_body.nil?
        @failed << message
      elsif response.code == 404 && !response_body['name'].present? && !response_body['description'].present? && !response_body['brand'].present? && !response_body['cost'].present?
        @success << message
      end
    rescue Net::ReadTimeout
      @failed << message
    end

    def should_delete_a_product
      response = HTTParty.delete("#{@url}/api/v1/products/#{@product_id}", headers: @headers, timeout: 5)
      response_body = verify_content_type(response)
      message = 'DELETE - should delete a product'

      if response_body.nil?
        @failed << message
      elsif response.code == 200
        @success << message
      end
    rescue Net::ReadTimeout
      @failed << message
    end

    def should_not_delete_a_product_if_it_is_not_found
      response = HTTParty.delete("#{@url}/api/v1/products/#{@product_id}", headers: @headers, timeout: 5)
      response_body = verify_content_type(response)
      message = 'DELETE - should not delete a product if it is not found'

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
