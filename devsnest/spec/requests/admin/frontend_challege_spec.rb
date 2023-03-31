# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::FrontendChallengeController, type: :request do
  let!(:user) { create(:user, user_type: 1) }
  let!(:user1) { create(:user, user_type: 0) }
  let!(:course) { create(:course, name: 'Test Course') }
  let!(:course_curriculum) { create(:course_curriculum, course_id: course.id) }
  let(:challenge) do
    create(:frontend_challenge, name: 'Draw Face', day_no: '1', topic: 'html', difficulty: 'easy', question_body: '', user_id: user.id, course_curriculum_id: course_curriculum.id)
  end
  let(:challenge1) do
    create(:frontend_challenge, name: 'Draw Face1', day_no: '1', topic: 'html', difficulty: 'easy', question_body: '', user_id: user1.id, course_curriculum_id: course_curriculum.id)
  end
  context 'index call' do
    it 'returns unauthorized response on non admin users' do
      get '/api/v1/admin/frontend-challenge', headers: HEADERS
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns a success response on admin users' do
      sign_in(user)
      get '/api/v1/admin/frontend-challenge', headers: HEADERS
      expect(response).to have_http_status(:ok)
    end
  end

  context '#self_created_challenges' do
    it 'returns a list of challenges created by the current user' do
      sign_in(user)
      get '/api/v1/admin/frontend-challenge/self_created_challenges', headers: headers

      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:id]).to eq(user.id)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:type]).to eq('frontend_challenges')
    end

    it 'returns an error if user is not authenticated' do
      sign_in(user1)
      get '/api/v1/admin/frontend-challenge/self_created_challenges'
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'add files' do
    it 'attaches files to the specified frontend challenge' do
      sign_in(user)
      put "/api/v1/admin/frontend-challenge/#{challenge.id}", params: {
        "data": {
          "id": challenge.id,
          "type": 'frontend_challenges',
          "attributes": {
            "files": {
              "/index.html": 'html',
              "/src/run.js": 'run',
              "/src/script.js": 'script',
              "/src/test.js": '// some bug happen not deleted',
              "/src/setup.js": 'setup',
              "/package.json": 'package'
            }
          }
        }
      }.to_json, headers: HEADERS

      expect(response).to have_http_status(:ok)
    end

    it 'returns an error if challenge does not exist' do
      sign_in(user)
      put '/api/v1/admin/frontend-challenge/999', params: {
        data: {
          id: 999,
          type: 'frontend-challenge',
          attributes: {
            "files": {
              "/index.html": 'html',
              "/src/run.js": 'run',
              "/src/script.js": 'script',
              "/src/test.js": '// some bug happen not deleted',
              "/src/setup.js": 'setup',
              "/package.json": 'package'
            }
          }
        }
      }, headers: HEADERS

      expect(response).to have_http_status(:not_found)
    end

    it 'returns an error if user is not authorized' do
      put "/api/v1/admin/frontend-challenge/#{challenge.id}", params: {
        data: {
          id: challenge.id,
          type: 'frontend-challenge',
          attributes: {
            "files": {
              "/index.html": 'html',
              "/src/run.js": 'run',
              "/src/script.js": 'script',
              "/src/test.js": '// some bug happen not deleted',
              "/src/setup.js": 'setup',
              "/package.json": 'package'
            }
          }
        }
      }, headers: HEADERS

      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'when the challenge exists' do
    before do
      sign_in(user)
      delete "/api/v1/admin/frontend-challenge/#{challenge.id}", headers: HEADERS
    end
    it 'returns a success response' do
      expect(response).to have_http_status(204)
    end

    it 'deletes the challenge' do
      expect(FrontendChallenge.find_by(id: challenge.id)).to be_nil
    end

    it 'removes the challenge files from S3' do
      bucket = 'frontend-testcases'
      files = $s3.list_objects(bucket: "#{ENV['S3_PREFIX']}#{bucket}", prefix: "#{challenge.id}/")

      expect(files.contents).to be_empty
    end
  end

  context 'when the challenge does not exist' do
    it 'returns a not found response' do
      sign_in(user)
      delete "/api/v1/admin/frontend-challenge/#{challenge.id + 1}", headers: HEADERS
      expect(response).to have_http_status(:not_found)
    end
  end

  context 'when user is authenticated as admin' do
    it 'returns a success response with active frontend challenges' do
      sign_in(user)
      get '/api/v1/admin/frontend-challenge/active_questions', headers: HEADERS
      expect(response).to have_http_status(:success)
    end
  end

  context 'when user is not authenticated as admin' do
    it 'returns an unauthorized response' do
      sign_in(user1)
      get '/api/v1/admin/frontend-challenge/active_questions', headers: HEADERS
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'files io' do
    it 'updates files with success response' do
      sign_in(user)
      io_boilerplate_mock = double('io_boilerplate')
      allow(io_boilerplate_mock).to receive(:call)
      post '/api/v1/admin/frontend-challenge/files_io', params: {
        data: {
          attributes: {
            'id': challenge.id,
            "action": 'add',
            "files": {
              "/index.html": 'html',
              "/src/run.js": 'run',
              "/src/script.js": 'script',
              "/src/test.js": '// some bug happen not deleted',
              "/src/setup.js": 'setup',
              "/package.json": 'package'
            }
          }
        }
      }.to_json, headers: HEADERS
      expect(response).to have_http_status(:success)
    end

    it 'returns a challenge not found response' do
      sign_in(user)
      io_boilerplate_mock = double('io_boilerplate')
      allow(io_boilerplate_mock).to receive(:call)
      post '/api/v1/admin/frontend-challenge/files_io', params: {
        data: {
          attributes: {
            'id': challenge.id + 1,
            "action": 'add',
            "files": {
              "/index.html": 'html',
              "/src/run.js": 'run',
              "/src/script.js": 'script',
              "/src/test.js": '// some bug happen not deleted',
              "/src/setup.js": 'setup',
              "/package.json": 'package'
            }
          }
        }
      }.to_json, headers: HEADERS
      expect(response).to have_http_status(:not_found)

    end
  end
end
