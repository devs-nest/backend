# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'JobApplication', type: :request do
  let(:user) { create(:user) }
  let(:organization) { create(:organization) }
  let(:job) { create(:job, organization_id: organization.id) }
  let!(:job_application) { create(:job_application, user_id: user.id, job_id: job.id) }

  context 'GET - Job Applications' do
    let(:user2) { create(:user) }
    it 'should not return the job applications if user is not logged in' do
      get '/api/v1/job-applications'
      expect(response).to have_http_status(401)
    end

    it 'should return all the job applications' do
      sign_in(user)
      get '/api/v1/job-applications'
      expect(response).to have_http_status(200)
    end

    it 'should show the job application of current user with specific id' do
      sign_in(user)
      get "/api/v1/job-applications/#{job_application.id}"
      expect(response).to have_http_status(200)
    end

    it 'should not show the job application of other user with specific id' do
      sign_in(user2)
      get "/api/v1/job-applications/#{job_application.id}"
      expect(response).to have_http_status(401)
    end
  end

  context 'POST - Job Applications' do
    let(:user2) { create(:user) }

    let(:params) do
      {
        data: {
          attributes: {
            job_id: job.id,
            user_id: user2.id
          },
          type: 'job_applications'
        }
      }
    end

    it 'should create a job application' do
      sign_in(user2)
      expect do
        post '/api/v1/job-applications', params: params.to_json, headers: HEADERS
      end.to change { JobApplication.count }.by(1)
      expect(response).to have_http_status(201)
    end

    it 'should not create a job application if user is not signed in' do
      expect do
        post '/api/v1/job-applications', params: params.to_json, headers: HEADERS
      end.to change { JobApplication.count }.by(0)

      expect(response).to have_http_status(401)
    end
  end

  context 'PUT - Job Applications' do
    let(:params) do
      {
        data: {
          id: job_application.id,
          attributes: {
            note_for_the_recruiter: 'hire me :cries:'
          },
          type: 'job_applications'
        }
      }
    end

    it 'should not update a job application if user is not signed in' do
      put "/api/v1/job-applications/#{job_application.id}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(401)
    end

    it 'should update a job application when user is signed in' do
      sign_in(user)
      put "/api/v1/job-applications/#{job_application.id}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(200)
    end
  end
end
