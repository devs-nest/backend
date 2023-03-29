# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AssignmentQuestion, type: :request do
  let(:user) { create(:user) }
  let!(:course) { create(:course, name: 'test') }
  let!(:course_curriculum) { create(:course_curriculum, course_id: course.id, course_type: 'dsa') }
  let!(:question) { create(:challenge, topic: 0, question_body: 'testbody xyz', user_id: user.id, name: 'two sum test', is_active: true, score: 100, difficulty: 'medium') }
  before :each do
    sign_in(user)
  end

  context 'AssignmentQuestion - Permission Checks' do
    it 'If User is not Admin' do
      get '/api/v1/admin/assignment-question'

      expect(response.status).to eq(401)
    end

    it 'If User is Admin' do
      user.update(user_type: 1)
      get '/api/v1/admin/assignment-question'

      expect(response.status).to eq(200)
    end
  end

  context 'Add AssignmentQuestion' do
    let!(:params) do
      {
        "data": {
          "course_curriculum_id": course_curriculum.id,
          "questions_data": [
            {
              "id": question.id,
              "type": 'Challenge'
            }
          ]
        }
      }.with_indifferent_access
    end

    before(:each) do
      user.update(user_type: 1)
    end
    it 'Should add Assignment Question Succesfully!' do
      user.update(user_type: 1)
      post '/api/v1/admin/assignment-question/add_assignment_questions', params: params, as: :json, headers: HEADERS
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['attributes']['message']).to eq('Questions Added Succesfully!')
    end

    it 'Should throw error when challenge type is invalid' do
      user.update(user_type: 1)
      params[:data][:questions_data].first[:type] = 'Invalid'
      post '/api/v1/admin/assignment-question/add_assignment_questions', params: params, as: :json, headers: HEADERS
      expect(response.status).to eq(400)
      expect(JSON.parse(response.body)['data']['attributes']['error']).to eq('Some Error occurred')
    end
  end
end
