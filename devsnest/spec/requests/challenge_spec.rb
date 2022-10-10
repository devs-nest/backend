# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Challenge, type: :request do
  context 'Challenge - request specs' do
    context 'get Content' do
      let(:user) { create(:user) }
      let(:question) { create(:challenge, user_id: user.id, name: 'two sum') }
      let(:algosub) { create(:algo_submission, user_id: user.id, challenge_id: question.id, status: 'Accepted', is_submitted: true) }

      it 'should return Challenges when exists' do
        get '/api/v1/challenge'
        expect(response).to have_http_status(200)
      end

      it 'should return Challenges when fetched by its slug' do
        get "/api/v1/challenge/fetch_by_slug?slug=#{question.name.parameterize}"
        expect(response).to have_http_status(200)
      end

      it 'should return Submission for the challenge' do
        sign_in(user)
        get "/api/v1/challenge/#{question.id}/submissions"
        expect(response).to have_http_status(200)
      end

      it 'should get all companies for the challenge challenge' do
        sign_in(user)
        get "/api/v1/challenge/#{question.id}/companies"
        expect(response).to have_http_status(200)
      end

      it 'should get all challenges with a single company id' do
        sign_in(user)
        get '/api/v1/challenge?filter[company_id]=1'
        expect(response).to have_http_status(200)
      end

      it 'should get all challenges with multiple company ids' do
        sign_in(user)
        get '/api/v1/challenge?filter[company_id]=1,2'
        expect(response).to have_http_status(200)
      end
    end

    context 'Leaderboard' do
      let!(:question) do
        create(:challenge, topic: 0, question_body: 'testbody xyz', user_id: user.id, name: 'two sum test', is_active: true, score: 100,
                           input_format: [{ "name": 'n', "variable": { "dtype": 'int', "dependent": [], "datastructure": 'primitive' } }, { "name": 'arr', "variable": { "dtype": 'int', "dependent": ['n'], "datastructure": 'array' } }],
                           output_format: [{ "name": 'out', "variable": { "dtype": 'int', "datastructure": 'array' } }])
      end
      let!(:ch_leaderboard) { question.generate_leaderboard }
      let!(:user) { create(:user, discord_active: true, username: 'username') }
      before :each do
        question.regenerate_challenge_leaderboard
      end

      it 'returns data of logged in users when user is logged in ' do
        sign_in(user)
        get "/api/v1/challenge/leaderboard?id=#{question.id}", headers: HEADERS
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:scoreboard].count).to eq(ch_leaderboard.leaders(1).count)
      end

      it 'retrun data of logged in users when user is bot ' do
        get "/api/v1/challenge/leaderboard?id=#{question.id}", params: { "data": { "attributes": { "discord_id": user.discord_id } } }, headers: {
          'ACCEPT' => 'application/vnd.api+json',
          'CONTENT-TYPE' => 'application/vnd.api+json',
          'Token' => ENV['DISCORD_TOKEN'],
          'User-Type' => 'Bot'
        }
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:scoreboard].count).to eq(ch_leaderboard.leaders(1).count)
      end
    end
  end
end
