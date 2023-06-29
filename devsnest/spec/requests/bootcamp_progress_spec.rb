# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'BootcampProgress', type: :request do
  context 'get bootcamp_progresses' do
    let!(:course) { create(:course) }
    let!(:course_curriculum) {  create(:course_curriculum, course_id: course.id, course_type: 'dsa') }
    let!(:user) { create(:user) }
    let!(:bootcamp_progress) { create(:bootcamp_progress, user_id: user.id, course_id: course.id, course_curriculum_id: course_curriculum.id) }

    it 'should return the bootcamp_progresses if user is signed in' do
      sign_in(user)
      get '/api/v1/bootcamp-progresses'
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['data'].count).to eq(1)
      expect(JSON.parse(response.body)['data'].first['user_id']).to eq(user.id)
    end

    it 'should not return the bootcamp_progresses if the user is not logged in' do
      get '/api/v1/batch-leader-sheet'
      expect(response).to have_http_status(401)
    end
  end

  context 'Create bootcamp_progress' do
    let!(:course) { create(:course) }
    let!(:course_curriculum) {  create(:course_curriculum, course_id: course.id, course_type: 'dsa') }
    let!(:user) { create(:user) }
    let!(:email_template) { create(:email_template, name: 'bootcamp_welcome_mail', template_id: '12345678') }
    let!(:params) do
      {
        "data": {
          "type": 'bootcamp_progresses',
          "attributes": {
            "user_id": user.id,
            "course_id": course.id,
            "course_type": 'dsa'
          }
        }
      }.with_indifferent_access
    end
    before(:each) do
      sign_in(user)
    end

    it 'should not create if course id is not present and return unproccesable entity' do
      params['data']['attributes'].delete('course_id')
      post '/api/v1/bootcamp-progresses', params: params, as: :json, headers: HEADERS
      expect(response).to have_http_status(422)
    end

    it 'should create bootcamp progress with the last course curriculum id of course' do
      post '/api/v1/bootcamp-progresses', params: params, as: :json, headers: HEADERS
      expect(response).to have_http_status(201)
      expect(JSON.parse(response.body)['data']['attributes']['course_curriculum_id']).to eq(course_curriculum.id)
    end
  end

  context 'Complete Day' do
    let!(:course) { create(:course) }
    let!(:course_curriculum2) { create(:course_curriculum, course_id: course.id, course_type: 'dsa') }
    let!(:course_curriculum) {  create(:course_curriculum, course_id: course.id, course_type: 'dsa') }
    let!(:bootcamp_progress) { create(:bootcamp_progress, user_id: user.id, course_id: course.id, course_curriculum_id: course_curriculum2.id) }
    let!(:user) { create(:user) }
    let!(:email_template) { create(:email_template, name: 'bootcamp_completion_mail', template_id: '12345678') }
    let!(:params) do
      {
        "data": {
          "type": 'bootcamp_progresses',
          "attributes": {
            "user_id": user.id,
            "course_curriculum_id": course_curriculum2.id
          }
        }
      }.with_indifferent_access
    end
    before(:each) do
      sign_in(user)
    end

    it 'should complete the day and assign next course curriculum id' do
      post '/api/v1/bootcamp-progresses/complete_day', params: params, as: :json, headers: HEADERS
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['data']['attributes']['message']).to eq('Day Completed!')
      expect(JSON.parse(response.body)['data']['attributes']['bootcamp_progress']['course_curriculum_id']).to eq(course_curriculum.id)
    end

    it 'should complete the bootcamp when last course curriculum id is passed' do
      params[:data][:attributes][:course_curriculum_id] = course_curriculum.id
      bootcamp_progress.update(course_curriculum_id: course_curriculum.id)
      post '/api/v1/bootcamp-progresses/complete_day', params: params, as: :json, headers: HEADERS
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['data']['attributes']['message']).to eq('Bootcamp Completed!')
      expect(JSON.parse(response.body)['data']['attributes']['bootcamp_progress']['course_curriculum_id']).to eq(course_curriculum.id)
    end
  end
end
