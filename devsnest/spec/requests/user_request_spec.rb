# frozen_string_literal: true

require 'rails_helper'
require 'leaderboard'

RSpec.describe Api::V1::UsersController, type: :request do
  context 'onboarding' do
    let(:user) { create(:user, discord_active: true) }
    let(:controller) { Api::V1::UsersController }

    before :each do
      # @mock_controller.stub(:current_user).and_return(User.first)
      sign_in(user)
    end

    let(:parameters) do
      {
        "data": {
          "type": 'onboards',
          "attributes": {
            "discord_username": 'KayDee#8576',
            "discord_id": '1234567890',
            "name": 'KayDee',
            "college_name": 'TestGrp',
            "grad_year": 2,
            "work_exp": '2mnth',
            "known_from": 'Friend',
            "dsa_skill": 4,
            "webd_skill": 3,
            "is_discord_form_filled": true
          }
        }
      }
    end

    it 'basic first put call' do
      put '/api/v1/users/onboard', params: parameters.to_json, headers: HEADERS
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:message]).to eq('Form filled')
    end

    it 'basic put call when user already filled the form' do
      user.update(is_discord_form_filled: true)
      put '/api/v1/users/onboard', params: parameters.to_json, headers: HEADERS
      expect(response.status).to eq(400)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:error][:message]).to eq('Discord form already filled')
    end

    it "when user's discord is not connected" do
      user.update(discord_active: false)
      put '/api/v1/users/onboard', params: parameters.to_json, headers: HEADERS
      expect(response.status).to eq(400)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:error][:message]).to eq("Discord isn't connected")
    end

    it 'when user is already in group' do
      group = create(:group)
      create(:group_member, user_id: user.id, group_id: group.id)
      put '/api/v1/users/onboard', params: parameters.to_json, headers: HEADERS
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
      expect(JSON.parse(response.body, symbolize_names: true)[:bot_token]).to eq(user.bot_token)
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
      expect(JSON.parse(response.body, symbolize_names: true)[:scoreboard].count).to eq(spec_leaderboard.leaders(1).count)
    end

    it 'retrun data of logged in users when user is bot ' do
      get '/api/v1/users/leaderboard', params: { "data": { "attributes": { "discord_id": user.discord_id } } }, headers: {
        'ACCEPT' => 'application/vnd.api+json',
        'CONTENT-TYPE' => 'application/vnd.api+json',
        'Token' => ENV['DISCORD_TOKEN'],
        'User-Type' => 'Bot'
      }
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:scoreboard].count).to eq(spec_leaderboard.leaders(1).count)
    end
  end

  context 'Report' do
    let!(:user) { create(:user, discord_active: true, discord_id: 123_456_789) }
    it ' return unauthorized if user is not logged in or not a known bot' do
      get '/api/v1/users/report', headers: HEADERS
      expect(response.status).to eq(401)
    end
    it 'retrun error when user not logged ' do
      get '/api/v1/users/report', params: { "discord_id": '1234' }, headers: {
        'ACCEPT' => 'application/vnd.api+json',
        'CONTENT-TYPE' => 'application/vnd.api+json',
        'Token' => ENV['DISCORD_TOKEN'],
        'User-Type' => 'Bot'
      }
      expect(response.status).to eq(400)
    end
    it 'returns data of discord users when user is on discord ' do
      get '/api/v1/users/report', params: { "discord_id": 123_456_789 }, headers: {
        'ACCEPT' => 'application/vnd.api+json',
        'CONTENT-TYPE' => 'application/vnd.api+json',
        'Token' => ENV['DISCORD_TOKEN'],
        'User-Type' => 'Bot'
      }
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)).to eq({
                                                                       "total_ques": Content.where(data_type: 0).count,
                                                                       "total_solved_ques": Content.joins(:submission).where(submissions: { status: 0, user_id: user.id },
                                                                                                                             contents: { data_type: 0 }).count
                                                                     })
    end
    it 'returns data of logged in users when user is logged in ' do
      sign_in(user)
      get '/api/v1/users/report', params: { "days": 7 }, headers: HEADERS
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)).to eq({
                                                                       "total_ques": Content.where(data_type: 0).count,
                                                                       "total_solved_ques": Content.joins(:submission).where(submissions: { status: 0, user_id: user.id },
                                                                                                                             contents: { data_type: 0 }).count
                                                                     })
    end

    it 'retrun data of logged in users when user is bot ' do
      sign_in(user)
      get '/api/v1/users/report', params: { "days": 7 }, headers: {
        'ACCEPT' => 'application/vnd.api+json',
        'CONTENT-TYPE' => 'application/vnd.api+json',
        'Token' => ENV['DISCORD_TOKEN'],
        'User-Type' => 'Bot'
      }
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)).to eq({
                                                                       "total_ques": Content.where(data_type: 0).count,
                                                                       "total_solved_ques": Content.joins(:submission).where(submissions: { status: 0, user_id: user.id },
                                                                                                                             contents: { data_type: 0 }).count
                                                                     })
    end
  end

  context 'Update Username' do
    let!(:user) { create(:user, username: 'adhikramm') }
    let!(:user2) { create(:user, username: 'adhikrammm') }
    it 'render unauthorized if user is not logged in' do
      put "/api/v1/users/#{user.id}", params: {

        "data": {
          "id": user.id.to_s,
          "type": 'users',

          "attributes": {
            'username': 'adhikrammm'
          }
        }

      }.to_json, headers: HEADERS
      expect(response.status).to eq(401)
    end
    it 'render unauthorized if user wants to change others username' do
      sign_in(user)
      put "/api/v1/users/#{user2.id}", params: {

        "data": {
          "id": user2.id.to_s,
          "type": 'users',

          "attributes": {
            "username": 'adhikrammm'
          }
        }

      }.to_json, headers: HEADERS
      expect(response.status).to eq(401)
    end

    it 'render error if username pattern does not match' do
      sign_in(user)
      put "/api/v1/users/#{user.id}", params: {
        "data": {
          "id": user.id.to_s,
          "type": 'users',
          "attributes": {
            "username": 'adhikramm/m'
          }
        }
      }.to_json, headers: HEADERS
      expect(response.status).to eq(400)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:error][:message]).to eq('Username pattern mismatched')
    end
    it 'render error if user with same username already exist' do
      sign_in(user)
      user2.update(username: 'adhikram')
      put "/api/v1/users/#{user.id}", params: {
        "data": {
          "id": user.id.to_s,
          "type": 'users',
          "attributes": {
            "username": user2.username
          }
        }
      }.to_json, headers: HEADERS
      expect(response.status).to eq(400)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:error][:message]).to eq('User already exists')
    end
    it 'render error if user update count is equals to 4' do
      sign_in(user)
      user.update(update_count: 4)
      put "/api/v1/users/#{user.id}", params: {
        "data": {
          "id": user.id.to_s,
          "type": 'users',
          "attributes": {
            "username": 'adhikramm'
          }
        }
      }.to_json, headers: HEADERS
      expect(response.status).to eq(400)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:error][:message]).to eq('Update count Exceeded for username')
    end
    it 'It changes the update count if all autherization passed and update the username' do
      sign_in(user)
      put "/api/v1/users/#{user.id}", params: {
        "data": {
          "id": user.id.to_s,
          "type": 'users',
          "attributes": {
            "username": 'adhikram'
          }
        }
      }.to_json, headers: HEADERS
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:username]).to eq('adhikram')
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
      expect(JSON.parse(response.body, symbolize_names: true)[:notice]).to eq('You logged out successfully')
    end
  end

  context 'Create ' do
    let!(:user) { create(:user, discord_active: false) }
    let(:bot_headers) do
      {
        'ACCEPT' => 'application/vnd.api+json',
        'CONTENT-TYPE' => 'application/vnd.api+json',
        'Token' => ENV['DISCORD_TOKEN'],
        'User-Type' => 'Bot'
      }
    end
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
    it 'updates discord active to true when user login ' do
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
  context 'Update discord username through bot ' do
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
end
