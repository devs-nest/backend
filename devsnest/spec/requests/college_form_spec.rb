# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'College Form Spec', type: :request do
  context 'Create Check' do
    let(:user) { create(:user) }
    it 'should give an error if user is not logged in' do
      post '/api/v1/college-form'
      expect(response).to have_http_status(401)
    end
    let(:params) do
      {
        "data": {
          "attributes": {
            "user_id": user.id,
            "tpo_or_faculty_name": 'Mr. Ravi',
            "college_name": 'JECRC College',
            "faculty_position": 'Head faculty',
            "email": 'hello@lol.com',
            "phone_number": '9852147852'
          },
          "type": 'college_forms'
        }
      }
    end

    it 'should create a for if user is logged in' do
      sign_in(user)
      post '/api/v1/college-form', params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(201)
    end

    it 'should not create a form if user have already filled a form' do
      CollegeForm.create(user_id: user.id, tpo_or_faculty_name: 'Mr. Ravi')
      sign_in(user)
      post '/api/v1/college-form', params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(422)
    end
  end
end
