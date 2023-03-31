# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::FrontendChallengeController, type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:user, user_type: 1) }
  let!(:course) { create(:course, name: 'Test Course') }
  let!(:course_curriculum) { create(:course_curriculum, course_id: course.id) }
  let(:challenge) do
    create(:frontend_challenge, name: 'Draw Face', day_no: '1', topic: 'html', difficulty: 'easy', question_body: '', user_id: user.id, course_curriculum_id: course_curriculum.id,
                                folder_name: 'draw-face', testcases_path: 'draw-face/testcases', active_path: 'index.html', open_paths: '["/index.html"]', protected_paths: '["/index.html"]',
                                hidden_files: '["/index.html"]', template: 'js', challenge_type: 'frontend', files: [])
  end
  let(:challenge_id) { challenge.id }
  let(:slug) { challenge.slug }
  let!(:callback_hearders) { { 'Content-Type': 'application/vnd.api+json', 'Accept': 'application/vnd.api+json', 'Token': user.bot_token } }
  before :each do
    sign_in(user)
  end

  context 'show call' do
    it 'returns a success response' do
      s3_object_mock = double('s3_object', body: double('body', read: 'file content'))
      s3_list_objects_mock = double('s3_list_objects', contents: [double('file', key: 'test-file')])
      allow($s3).to receive(:get_object).and_return(s3_object_mock)
      allow($s3).to receive(:list_objects).and_return(s3_list_objects_mock)
      get "/api/v1/frontend-challenge/#{challenge_id}", headers: HEADERS
      expect(response).to have_http_status(:ok)
    end
  end
  context 'when challenge is found' do
    it 'returns a success response' do
      s3_object_mock = double('s3_object', body: double('body', read: 'file content'))
      s3_list_objects_mock = double('s3_list_objects', contents: [double('file', key: 'test-file')])
      allow($s3).to receive(:get_object).and_return(s3_object_mock)
      allow($s3).to receive(:list_objects).and_return(s3_list_objects_mock)
      get '/api/v1/frontend-challenge/fetch_by_slug', headers: HEADERS, params: { slug: slug }
      expect(response).to have_http_status(:ok)
    end

    it 'returns the challenge with its files' do
      get '/api/v1/frontend-challenge/fetch_by_slug', headers: HEADERS, params: { slug: slug }
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:name]).to eq(challenge.name)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:day_no]).to eq(challenge.day_no)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:topic]).to eq(challenge.topic)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:slug]).to eq(challenge.slug)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:difficulty]).to eq(challenge.difficulty)
    end
  end

  context 'when challenge is not found' do
    it 'returns a not found response' do
      get '/api/v1/frontend-challenge/fetch_by_slug', headers: HEADERS, params: { slug: 'invalid-slug' }
      expect(response).to have_http_status(:not_found)
    end
  end

  context 'when challenge is found' do
    it 'returns a success response' do
      sign_in(user)
      s3_object_mock = double('s3_object', body: double('body', read: 'file content'))
      allow($s3).to receive(:get_object).and_return(s3_object_mock)
      get '/api/v1/frontend-challenge/fetch_frontend_testcases', headers: callback_hearders, params: { id: challenge_id, data: { attributes: { user_id: user.id } } }
      expect(response).to have_http_status(:ok)
    end
  end
end
