# frozen_string_literal: true

require 'rails_helper'

URL = 'https://todo-list-app.herokuapp.com'

RSpec.describe 'Todo List', type: :request do
  context 'post register_new_user' do
    it 'should register a new user' do
      body = {
        username: 'user1',
        email: 'user1@gmail.com',
        password: 'abcde12345'
      }
      headers = {
        'Content-Type' => 'application/json'
      }

      response = HTTParty.post("#{URL}/user/signup", body: body.to_json, headers: headers)

      expect(response.code).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:title]).to eq('user created')
    end

    it 'should not register a new user if email is not provided' do
      body = {
        username: 'user1',
        password: 'abcd12345'
      }
      headers = {
        'Content-Type' => 'application/json'
      }

      response = HTTParty.post("#{URL}/user/signup", body: body.to_json, headers: headers)
      expect(response.code).to eq(400)
    end

    # it 'should not register a new user if username is not provided' do
    #   body = {
    #     email: 'user1@gmail.com',
    #     password: 'user12345'
    #   }
    #   headers = {
    #     'Content-Type' => 'application/json'
    #   }

    #   response = HTTParty.post("#{URL}/user/signup", body: body.to_json, headers: headers)
    #   expect(response.code).to eq(400)
    # end

    it 'should not register a new user if password is not provided' do
      body = {
        username: 'user1',
        email: 'user1@gmail.com'
      }
      headers = {
        'Content-Type' => 'application/json'
      }

      response = HTTParty.post("#{URL}/user/signup", body: body.to_json, headers: headers)
      expect(response.code).to eq(400)
    end
  end

  context 'post login_new_user' do
    it 'should login user if correct credentials are provided' do
      body = {
        email: 'user1@gmail.com',
        password: 'abcde12345'
      }
      headers = {
        'Content-Type' => 'application/json'
      }

      response = HTTParty.post("#{URL}/user/login", body: body.to_json, headers: headers)
      expect(JSON.parse(response.body, symbolize_names: true)[:title]).to eq('login success')
      expect(JSON.parse(response.body, symbolize_names: true)[:token]).to be_present
    #   token = response.body.token
      # need to save token from response
    end

    it 'should not login if incorrect credentials are provided' do
      body = {
        email: 'user1@gmail.com',
        password: 'sadfuifu9238ry2h38wef92f8h9238928b'
      }
      headers = {
        'Content-Type' => 'application/json'
      }

      response = HTTParty.post("#{URL}/user/login", body: body.to_json, headers: headers)
    end
  end
end
