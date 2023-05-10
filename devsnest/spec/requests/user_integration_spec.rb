# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UserIntegration', type: :request do
  let(:user) { create(:user) }

  before :each do
    sign_in(user)
  end

  context 'Links' do
    it 'should not return links if user is not authenticated' do
      sign_out(user)
      get '/api/v1/user-integration/links'
      expect(response).to have_http_status(401)
    end

    it 'should create UserIntegration for a user' do
      params = {
        "data": {
          "attributes": {
            "leetcode_user_name": SecureRandom.hex(3)
          },
          "type": 'user_integrations'
        }
      }

      put '/api/v1/user-integration/update_links', params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(200)
    end

    it 'should update UserIntegration for a user' do
      user.user_integration = UserIntegration.create!(leetcode_user_name: SecureRandom.hex(3), user_id: user.id)
      params = {
        "data": {
          "attributes": {
            "leetcode_user_name": SecureRandom.hex(3)
          },
          "type": 'user_integrations'
        }
      }

      put '/api/v1/user-integration/update_links', params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(200)
    end
  end

  context 'leetcode' do
    # it 'should not return data if leetcode username is blank' do
    #   get "/api/v1/user-integration/leetcode?username=#{user.username}"
    #   expect(response).to have_http_status(400)
    # end

    it 'should return leetcode data of valid user' do
      user.user_integration = UserIntegration.create!(leetcode_user_name: 'leetcode', user_id: user.id)
      get "/api/v1/user-integration/leetcode?username=#{user.username}"
      expect(response).to have_http_status(200)
    end

    it 'should return leetcode data from cache' do
      user.user_integration = UserIntegration.create!(leetcode_user_name: 'leetcode', user_id: user.id)
      get "/api/v1/user-integration/leetcode?username=#{user.username}" # adding data to cache
      get "/api/v1/user-integration/leetcode?username=#{user.username}" # requesting from cache
      expect(response).to have_http_status(200)
    end
  end

  # context 'gfg' do
  #   it 'should not return data if gfg username is invalid' do
  #     user.user_integration = UserIntegration.create!(gfg_user_name: "#{SecureRandom.hex(3)}gfg", user_id: user.id)
  #     get "/api/v1/user-integration/gfg?username=#{user.username}"
  #     expect(response).to have_http_status(400)
  #   end

  #   it 'should return gfg data for valid user' do
  #     user.user_integration = UserIntegration.create!(gfg_user_name: 'geeksforgeeks', user_id: user.id)
  #     get "/api/v1/user-integration/gfg?username=#{user.username}"
  #     expect(response).to have_http_status(200)
  #   end
  # end

  # context 'hackerrank' do
  #   it 'should not return data if hackerrank username is invalid' do
  #     user.user_integration = UserIntegration.create!(hackerrank_user_name: "#{SecureRandom.hex(3)}hackerrank", user_id: user.id)
  #     get "/api/v1/user-integration/hackerrank?username=#{user.username}"
  #     expect(response).to have_http_status(400)
  #   end

  #   it 'should return hackerrank data for valid user' do
  #     user.user_integration = UserIntegration.create!(hackerrank_user_name: 'hackerrank', user_id: user.id)
  #     get "/api/v1/user-integration/hackerrank?username=#{user.username}"
  #     byebug
  #     expect(response).to have_http_status(200)
  #   end
  # end
end
