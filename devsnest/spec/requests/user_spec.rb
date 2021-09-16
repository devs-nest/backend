# frozen_string_literal: true

require 'rails_helper'
require 'leaderboard'

RSpec.describe Api::V1::UsersController, type: :request do
  context 'onboarding basic check' do
    let(:user) { create(:user, discord_active: true) }
    let(:controller) { Api::V1::UsersController }

    before :each do
      # @mock_controller.stub(:current_user).and_return(User.first)
      sign_in(user)
    end

    it 'basic first put call' do
      put '/api/v1/users/onboard', params: USER_SPEC_PARAMS.to_json, headers: HEADERS
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:message]).to eq('Form filled')
    end

    it 'basic put call when user already filled the form' do
      user.update(is_discord_form_filled: true)
      put '/api/v1/users/onboard', params: USER_SPEC_PARAMS.to_json, headers: HEADERS
      expect(response.status).to eq(400)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:error][:message]).to eq('Discord form already filled')
    end
  end
  context 'onboarding' do
    let(:user) { create(:user, discord_active: true) }
    let(:controller) { Api::V1::UsersController }

    before :each do
      # @mock_controller.stub(:current_user).and_return(User.first)
      sign_in(user)
    end

    it "when user's discord is not connected" do
      user.update(discord_active: false)
      put '/api/v1/users/onboard', params: USER_SPEC_PARAMS.to_json, headers: HEADERS
      expect(response.status).to eq(400)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:error][:message]).to eq("Discord isn't connected")
    end

    it 'when user is already in group' do
      group = create(:group)
      create(:group_member, user_id: user.id, group_id: group.id)
      put '/api/v1/users/onboard', params: USER_SPEC_PARAMS.to_json, headers: HEADERS
      expect(response.status).to eq(400)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:error][:message]).to eq('User already in a group')
    end
  end

  context 'me' do
    let(:user) { create(:user, discord_active: true) }
    it 'raise render_unauthorized when user is not logged in' do
      get '/api/v1/users/me', headers: HEADERS
      expect(response.status).to eq(401)
    end
    it 'redirects user to @curren_user when user hits /me url when user is logged in ' do
      sign_in(user)
      get '/api/v1/users/me', headers: HEADERS do
        redirect "https://#{request.host}:#{request.port}/#{user.id}"
      end
    end
    it 'increase the login count when user hits /me url' do
      sign_in(user)
      get '/api/v1/users/me', headers: HEADERS
      expect(response.status).to eq(302)
      follow_redirect!
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:login_count]).to eq(1)
    end
  end

  context 'Get by username ' do
    let(:user) { create(:user, discord_active: true, username: 'username') }
    it 'raise render_not_found when username dont exist' do
      get '/api/v1/users/notuser/get_by_username', headers: HEADERS
      expect(response.status).to eq(404)
    end
    it 'redirects to user when it exists' do
      get "/api/v1/users/#{user.username}/get_by_username", headers: HEADERS do
        redirect "https://#{request.host}:#{request.port}/#{user.id}"
      end
    end
  end

  context 'Get Token' do
    let!(:user) { create(:user, discord_active: true, discord_id: 123_456_789) }
    it 'it return bot_token  when discord_id is valid ' do
      get '/api/v1/users/get_token', params: { "data": { "attributes": { "discord_id": '1234' } } }, headers: {
        'ACCEPT' => 'application/vnd.api+json',
        'CONTENT-TYPE' => 'application/vnd.api+json',
        'Token' => ENV['DISCORD_TOKEN'],
        'User-Type' => 'Bot'
      }
      expect(response.status).to eq(400)
    end
    it 'it return bot_token  when discord_id is valid ' do
      get '/api/v1/users/get_token', params: { "data": { "attributes": { "discord_id": user.discord_id } } }, headers: {
        'ACCEPT' => 'application/vnd.api+json',
        'CONTENT-TYPE' => 'application/vnd.api+json',
        'Token' => ENV['DISCORD_TOKEN'],
        'User-Type' => 'Bot'
      }
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:bot_token]).to eq(user.bot_token)
    end
  end

  context 'Leaderboard' do
    let(:spec_leaderboard) { Leaderboard.new(ENV['REDIS_DB'], Leaderboard::DEFAULT_OPTIONS, { redis_connection: Redis.new }) }
    let(:user) { create(:user, discord_active: true, username: 'username') }
    before :each do
      User.initialize_leaderboard(spec_leaderboard)
    end

    it ' return unauthorized if user is not logged in or not a known bot' do
      get '/api/v1/users/leaderboard', headers: HEADERS
      expect(response.status).to eq(401)
    end

    it 'returns data of logged in users when user is logged in ' do
      sign_in(user)
      get '/api/v1/users/leaderboard', headers: HEADERS
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:scoreboard].count).to eq(spec_leaderboard.leaders(1).count)
    end

    it 'retrun data of logged in users when user is bot ' do
      get '/api/v1/users/leaderboard', params: { "data": { "attributes": { "discord_id": user.discord_id } } }, headers: {
        'ACCEPT' => 'application/vnd.api+json',
        'CONTENT-TYPE' => 'application/vnd.api+json',
        'Token' => ENV['DISCORD_TOKEN'],
        'User-Type' => 'Bot'
      }
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:scoreboard].count).to eq(spec_leaderboard.leaders(1).count)
    end
  end

  context 'Report' do
    let!(:user) { create(:user, discord_active: true, discord_id: 123_456_789) }
    it ' return unauthorized if user is not logged in or not a known bot' do
      get '/api/v1/users/report', headers: HEADERS
      expect(response.status).to eq(401)
    end
    it 'returns data of logged in users when user is logged in ' do
      sign_in(user)
      get '/api/v1/users/report', params: { "days": 7 }, headers: HEADERS
      expect(response.status).to eq(200)
    end
  end

  context 'Report with bot headers' do
    let(:bot_headers) do
      {
        'ACCEPT' => 'application/vnd.api+json',
        'CONTENT-TYPE' => 'application/vnd.api+json',
        'Token' => ENV['DISCORD_TOKEN'],
        'User-Type' => 'Bot'
      }
    end
    let!(:user) { create(:user, discord_active: true, discord_id: 123_456_789) }

    it 'retrun error when user not logged ' do
      get '/api/v1/users/report', params: { "discord_id": '1234' }, headers: bot_headers
      expect(response.status).to eq(400)
    end
    it 'returns data of discord users when user is on discord ' do
      get '/api/v1/users/report', params: { "discord_id": 123_456_789 }, headers: bot_headers
      expect(response.status).to eq(200)
    end
    it 'retrun data of logged in users when user is bot ' do
      sign_in(user)
      get '/api/v1/users/report', params: { "days": 7 }, headers: bot_headers
      expect(response.status).to eq(200)
    end
  end

  context 'Update Username unauthorized check' do
    let!(:user) { create(:user, username: 'adhikramm') }
    let!(:user2) { create(:user, username: 'adhikrammm') }
    let(:user_params) do
      {

        "data": {
          "id": user.id.to_s,
          "type": 'users',

          "attributes": {
            'username': 'adhikrammm'
          }
        }
      }
    end

    it 'render unauthorized if user is not logged in' do
      put "/api/v1/users/#{user.id}", params: user_params.to_json, headers: HEADERS
      expect(response.status).to eq(401)
    end
    it 'render unauthorized if user wants to change others username' do
      sign_in(user)
      user_params[:data][:id] = user2.id.to_s
      put "/api/v1/users/#{user2.id}", params: user_params.to_json, headers: HEADERS
      expect(response.status).to eq(401)
    end
  end

  context 'Update Username basic username checks' do
    let!(:user) { create(:user, username: 'adhikramm') }
    let!(:user2) { create(:user, username: 'adhikrammm') }
    let(:user_params) do
      {
        "data": {
          "id": user.id.to_s,
          "type": 'users',

          "attributes": {
            'username': 'adhikram/m'
          }
        }
      }
    end

    it 'render error if username pattern does not match' do
      sign_in(user)
      put "/api/v1/users/#{user.id}", params: user_params.to_json, headers: HEADERS
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:error][:message]).to eq('Username pattern mismatched')
    end
    it 'render error if user with same username already exist' do
      sign_in(user)
      user2.update(username: 'adhikram')
      user_params[:data][:attributes][:username] = user2.username
      put "/api/v1/users/#{user.id}", params: user_params.to_json, headers: HEADERS
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:error][:message]).to eq('User already exists')
    end
  end

  context 'Update Username basic username checks' do
    let!(:user) { create(:user, username: 'adhikrammaitra') }
    let!(:user2) { create(:user, username: 'adhikrammm') }
    let(:user_params) do
      {

        "data": {
          "id": user.id.to_s,
          "type": 'users',

          "attributes": {
            'username': 'adhikrammm'
          }
        }
      }
    end

    it 'render error if user update count is equals to 4' do
      sign_in(user)
      user.update(update_count: 4)
      put "/api/v1/users/#{user.id}", params: user_params.to_json, headers: HEADERS
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:error][:message]).to eq('Update count Exceeded for username')
    end
    it 'It changes the update count if all autherization passed and update the username' do
      sign_in(user)
      put "/api/v1/users/#{user.id}", params: user_params.to_json, headers: HEADERS
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:update_count]).to eq(1)
    end
  end

  context 'Left Discord ' do
    let!(:user) { create(:user, discord_active: true) }
    let(:bot_headers) do
      {
        'ACCEPT' => 'application/vnd.api+json',
        'CONTENT-TYPE' => 'application/vnd.api+json',
        'Token' => ENV['DISCORD_TOKEN'],
        'User-Type' => 'Bot'
      }
    end
    it 'returns changes discord active tag when user left discord' do
      put '/api/v1/users/left_discord', params: {
        "data": {
          "type": 'users',
          "attributes":
          {
            "discord_id": user.discord_id.to_s

          }
        }
      }.to_json, headers: bot_headers
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:discord_active]).to eq(false)
    end
  end

  context 'logout' do
    let!(:user) { create(:user) }
    it 'return unauthorized if user is not logged in' do
      delete '/api/v1/users/logout', headers: HEADERS
      expect(response.status).to eq(401)
    end

    it ' shows logout message when user is logged in' do
      sign_in(user)
      delete '/api/v1/users/logout', headers: HEADERS
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:notice]).to eq('You logged out successfully')
    end
  end

  context 'Create without bot token' do
    let!(:user) { create(:user, discord_active: false) }
    it 'return unauthorized when bot token not set ' do
      post '/api/v1/users', params: {
        "data": {
          "type": 'users',
          "attributes":
          {
            "discord_id": user.discord_id.to_s

          }
        }
      }.to_json, headers: HEADERS
      expect(response.status).to eq(401)
    end
  end

  context 'Create while logging in' do
    let!(:user) { create(:user, discord_active: false) }
    let(:bot_headers) do
      {
        'ACCEPT' => 'application/vnd.api+json',
        'CONTENT-TYPE' => 'application/vnd.api+json',
        'Token' => ENV['DISCORD_TOKEN'],
        'User-Type' => 'Bot'
      }
    end
    it 'updates discord active to true when user login' do
      post '/api/v1/users', params: {
        "data": {
          "type": 'users',
          "attributes":
          {
            "discord_id": user.discord_id.to_s

          }
        }
      }.to_json, headers: bot_headers
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:discord_active]).to eq(true)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:status]).to eq('status updated')
    end
  end

  context 'Add markdown to the user ' do
    let!(:user) { create(:user, markdown: 'adhikramm') }
    it ' Changes the markdown of the user' do
      sign_in(user)
      put "/api/v1/users/#{user.id}", params: {
        "data": {
          "id": user.id.to_s,
          "type": 'users',
          "attributes": {
            "markdown": 'Software🌈 and Web developer🎯'
          }
        }
      }.to_json, headers: HEADERS
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:markdown]).to eq('Software🌈 and Web developer🎯')
    end
  end

  context 'Update discord username through bot (invalid discord id)' do
    let!(:user) { create(:user, discord_id: '123', discord_username: 'adhikramm') }
    let!(:bot_headers) do
      {
        'ACCEPT' => 'application/vnd.api+json',
        'CONTENT-TYPE' => 'application/vnd.api+json',
        'Token' => ENV['DISCORD_TOKEN'],
        'User-Type' => 'Bot'
      }
    end
    it ' It returns error if user discord id is invalid' do
      put '/api/v1/users/update_discord_username', params: {
        "data": {
          "type": 'users',
          "attributes":
          {
            "discord_id": 1,
            "discord_username": 'Arka'
          }
        }
      }.to_json, headers: bot_headers
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:error][:message]).to eq('User does not exist')
    end
  end
  context 'Update discord username through bot when user is valid' do
    let!(:user) { create(:user, discord_id: '123', discord_username: 'adhikramm') }
    let!(:bot_headers) do
      {
        'ACCEPT' => 'application/vnd.api+json',
        'CONTENT-TYPE' => 'application/vnd.api+json',
        'Token' => ENV['DISCORD_TOKEN'],
        'User-Type' => 'Bot'
      }
    end
    it ' Changes the discord_username of the user' do
      put '/api/v1/users/update_discord_username', params: {
        "data": {
          "type": 'users',
          "attributes":
          {
            "discord_id": user.discord_id,
            "discord_username": 'Arka'
          }
        }
      }.to_json, headers: bot_headers
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:discord_username]).to eq('Arka')
    end
  end
  context 'login' do
    let!(:user) { create(:user) }
    let!(:user1) { create(:user, email: '1@devsnest1.com') }
    let(:login_headers) do
      {
        "code": 'code',
        "googleId": '1234',
        "type": 'google'

      }.to_json
    end
    it ' New Login ' do
      allow(User).to receive_message_chain(:fetch_google_user_details).and_return({ 'name': 'Adhikram', 'email': '1@devsnest.com' }.as_json)
      post '/api/v1/users/login', params: login_headers, headers: HEADERS
      expect(response.status).to eq(200)
    end
    it ' Login for already existed user' do
      allow(User).to receive_message_chain(:fetch_google_user_details).and_return({ 'name': 'Adhikram', 'email': '1@devsnest1.com' }.as_json)
      post '/api/v1/users/login', params: login_headers, headers: HEADERS
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:email]).to eq(user1.email)
    end
  end
  context 'Connect discord with code ' do
    let!(:event) { create(:event, event_type: 'welcome', bot_type: 1) }
    let!(:event1) { create(:event, event_type: 'verification', bot_type: 0) }
    let!(:bot) { create(:notification_bot, bot_token: 'abchefljfhlf') }
    let!(:user1) { create(:user) }
    let!(:discord_user) { create(:user, discord_active: true, web_active: false) }
    let(:group) { create(:group, co_owner_id: discord_user.id) }
    let!(:group_member) { create(:group_member, group_id: group.id, user_id: discord_user.id) }
    it ' Connect discord ' do
      allow(User).to receive_message_chain(:fetch_discord_access_token).and_return('token')
      discord_user.update(discord_id: discord_user.id)
      allow(User).to receive_message_chain(:fetch_discord_user_details).and_return(discord_user.as_json)

      user1.update(bot_id: bot.id)
      sign_in(user1)

      post '/api/v1/users/connect_discord', params: {
        "code": 'code'

      }.to_json, headers: HEADERS
      expect(response.status).to eq(200)
    end
  end
  context 'Connect discord with token' do
    let!(:event) { create(:event, event_type: 'welcome', bot_type: 1) }
    let!(:event1) { create(:event, event_type: 'verification', bot_type: 0) }
    let(:bot) { create(:notification_bot, bot_token: 'abchefljfhlf') }
    let!(:user1) { create(:user) }
    let(:discord_user) { create(:user, discord_active: true, web_active: false) }
    let(:group) { create(:group, owner_id: discord_user.id) }
    let!(:group_member) { create(:group_member, group_id: group.id, user_id: discord_user.id) }
    it ' Connect discord ' do
      user1.update(bot_id: bot.id)
      sign_in(user1)

      post '/api/v1/users/connect_discord', params: {
        "data": {
          "type": 'users',
          "attributes":
          {
            "bot_token": discord_user.bot_token

          }
        }
      }.to_json, headers: HEADERS
      expect(response.status).to eq(200)
    end
  end
end
