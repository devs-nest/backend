# frozen_string_literal: true

require 'rails_helper'
require 'securerandom'

RSpec.describe 'Todo List', type: :request do
  uniq_username = SecureRandom.hex
  password = SecureRandom.hex
  auth_token = ''
  task_id = ''

  context 'post register_new_user' do
    it 'should register a new user' do
      body = {
        username: uniq_username,
        email: "#{uniq_username}_user1@gmail.com",
        password: password
      }
      headers = {
        'Content-Type' => 'application/json'
      }

      response = HTTParty.post("#{ENV['url']}/user/signup", body: body.to_json, headers: headers)
      expect(response.code).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:title]).to eq('user created')
    end

    it 'should not create a new user if email is already registered' do
      body = {
        username: uniq_username,
        email: "#{uniq_username}_user1@gmail.com",
        password: password
      }
      headers = {
        'Content-Type' => 'application/json'
      }
      response = HTTParty.post("#{ENV['url']}/user/signup", body: body.to_json, headers: headers)
      expect(response.code).to eq(400)
      expect(JSON.parse(response.body, symbolize_names: true)[:title]).to eq('error')
      expect(JSON.parse(response.body, symbolize_names: true)[:error]).to eq('email already in use')
    end

    it 'should not register a new user if email is not provided' do
      body = {
        username: 'user1',
        password: password
      }
      headers = {
        'Content-Type' => 'application/json'
      }

      response = HTTParty.post("#{ENV['url']}/user/signup", body: body.to_json, headers: headers)
      expect(response.code).to eq(400)
    end

    it 'should not register a new user if username is not provided' do
      body = {
        email: "#{SecureRandom.hex}_user1@gmail.com",
        password: password
      }
      headers = {
        'Content-Type' => 'application/json'
      }

      response = HTTParty.post("#{ENV['url']}/user/signup", body: body.to_json, headers: headers)
      expect(response.code).to eq(400)
    end

    it 'should not register a new user if password is not provided' do
      uniq_user = SecureRandom.hex
      body = {
        username: uniq_user.to_s,
        email: "#{uniq_user}_user1@gmail.com"
      }
      headers = {
        'Content-Type' => 'application/json'
      }

      response = HTTParty.post("#{ENV['url']}/user/signup", body: body.to_json, headers: headers)
      expect(response.code).to eq(400)
    end
  end

  context 'post login_new_user' do
    it 'should login user if correct credentials are provided' do
      body = {
        email: "#{uniq_username}_user1@gmail.com",
        password: password
      }
      headers = {
        'Content-Type' => 'application/json'
      }

      response = HTTParty.post("#{ENV['url']}/user/login", body: body.to_json, headers: headers)

      expect(response.code).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:title]).to eq('login success')
      expect(JSON.parse(response.body, symbolize_names: true)[:token]).to be_present

      auth_token = JSON.parse(response.body, symbolize_names: true)[:token] if response.code == 200
    end

    it 'should not login with incorrect password' do
      body = {
        email: "#{uniq_username}_user1@gmail.com",
        password: SecureRandom.hex
      }
      headers = {
        'Content-Type' => 'application/json'
      }
      response = HTTParty.post("#{ENV['url']}/user/login", body: body.to_json, headers: headers)
      expect(response.code).to eq(401)
      expect(JSON.parse(response.body, symbolize_names: true)[:title]).to eq('login failed')
      expect(JSON.parse(response.body, symbolize_names: true)[:error]).to eq('invalid username or password')
    end

    it 'should not login with incorrect email' do
      body = {
        email: "#{SecureRandom.hex}_user1@gmail.com",
        password: password
      }
      headers = {
        'Content-Type' => 'application/json'
      }
      response = HTTParty.post("#{ENV['url']}/user/login", body: body.to_json, headers: headers)
      expect(response.code).to eq(401)
      expect(JSON.parse(response.body, symbolize_names: true)[:title]).to eq('user not found')
    end
  end

  context 'get user_tasks' do
    it 'should return tasks of authenticated user' do
      headers = {
        Authorization: "Bearer #{auth_token}"
      }
      response = HTTParty.get("#{ENV['url']}/task", headers: headers)

      expect(response.code).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:title]).to eq('success')
      expect(JSON.parse(response.body, symbolize_names: true)[:todos]).to be_an_instance_of(Array)
      expect(JSON.parse(response.body, symbolize_names: true)[:todos].count).to eq(0)
    end

    it 'should not return tasks if user is not authenticated' do
      header = {
        Authorization: "Bearer #{SecureRandom.hex}"
      }
      response = HTTParty.get("#{ENV['url']}/task", headers: headers)
      expect(response.code).to eq(401)
      expect(JSON.parse(response.body, symbolize_names: true)[:title]).to eq('not authenticated')
      expect(JSON.parse(response.body, symbolize_names: true)[:todos]).to_not be_present
    end
  end

  context 'post user_tasks' do
    it 'should create a task' do
      headers = {
        'Content-Type' => 'application/json',
        Authorization: "Bearer #{auth_token}"
      }
      body = {
        title: 'Write RSpec for Users'
      }
      response = HTTParty.post("#{ENV['url']}/task", body: body.to_json, headers: headers)
      expect(response.code).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:title]).to eq('successfully added')
      expect(JSON.parse(response.body, symbolize_names: true)[:todo]).to be_present
      expect(JSON.parse(response.body, symbolize_names: true)[:todo][:title]).to eq('Write RSpec for Users')
      expect(JSON.parse(response.body, symbolize_names: true)[:todo][:completed]).to eq(false)

      task_id = JSON.parse(response.body, symbolize_names: true)[:todo][:_id] if response.code == 200
    end

    it 'should not create a task when user is not authorized' do
      headers = {
        'Content-Type' => 'application/json',
        Authorization: "Bearer #{SecureRandom.hex}"
      }
      body = {
        title: 'Write RSpec for Users'
      }
      response = HTTParty.post("#{ENV['url']}/task", body: body.to_json, headers: headers)
      expect(response.code).to eq(401)
      expect(JSON.parse(response.body, symbolize_names: true)[:title]).to eq('not authenticated')
      expect(JSON.parse(response.body, symbolize_names: true)[:todo]).to_not be_present
    end

    it 'should not create a task if title is not provided' do
      headers = {
        'Content-Type' => 'application/json',
        Authorization: "Bearer #{auth_token}"
      }
      body = {
        completed: false
      }
      response = HTTParty.post("#{ENV['url']}/task", body: body.to_json, headers: headers)
      expect(response.code).to eq(400)
      expect(JSON.parse(response.body, symbolize_names: true)[:title]).to eq('error')
      expect(JSON.parse(response.body, symbolize_names: true)[:todo]).to_not be_present
      expect(JSON.parse(response.body, symbolize_names: true)[:error]).to eq('Todo validation failed: title: Path `title` is required.')
    end

    it 'should return the newly created task' do
      headers = {
        Authorization: "Bearer #{auth_token}"
      }
      response = HTTParty.get("#{ENV['url']}/task", headers: headers)
      expect(response.code).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:title]).to eq('success')
      expect(JSON.parse(response.body, symbolize_names: true)[:todos].count).to eq(1)
      expect(JSON.parse(response.body, symbolize_names: true)[:todos][0][:title]).to eq('Write RSpec for Users')
      expect(JSON.parse(response.body, symbolize_names: true)[:todos][0][:completed]).to eq(false)
    end
  end

  context 'put user_tasks' do
    it 'should update the completed' do
      headers = {
        'Content-Type': 'application/json',
        Authorization: "Bearer #{auth_token}"
      }
      body = {
        completed: true
      }
      response = HTTParty.put("#{ENV['url']}/task/#{task_id}", body: body.to_json, headers: headers)
      expect(response.code).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:title]).to eq('todo updated')
      expect(JSON.parse(response.body, symbolize_names: true)[:todo][:completed]).to eq(true)
    end

    it 'should not update the task if user is not authenticated' do
      headers = {
        'Content-Type': 'application/json'
      }
      body = {
        completed: false
      }
      response = HTTParty.put("#{ENV['url']}/task/#{task_id}", body: body.to_json, headers: headers)
      expect(response.code).to eq(401)
      expect(JSON.parse(response.body, symbolize_names: true)[:title]).to eq('not authenticated')
    end
  end

  context 'delete user_tasks' do
    it 'should not delete the task if user is not authenticated' do
      response = HTTParty.delete("#{ENV['url']}/task/#{task_id}", body: body.to_json, headers: headers)
      expect(response.code).to eq(401)
      expect(JSON.parse(response.body, symbolize_names: true)[:title]).to eq('not authenticated')
    end

    it 'should delete the task' do
      headers = {
        Authorization: "Bearer #{auth_token}"
      }
      response = HTTParty.delete("#{ENV['url']}/task/#{task_id}", body: body.to_json, headers: headers)
      expect(response.code).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:title]).to eq('todo deleted')
    end
  end
end
