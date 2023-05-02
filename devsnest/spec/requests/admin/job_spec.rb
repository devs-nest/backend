# frozeon_string_literal: true

require 'rails_helper'

RSpec.describe 'Job', type: :request do
  let(:user) { create(:user) }
  let(:organization) { create(:organization) }
  let!(:job) { create(:job, organization_id: organization.id) }

  before :each do
    sign_in(user)
  end

  context 'GET - jobs' do
    it 'should not return the jobs if user is not admin' do
      get '/api/v1/admin/jobs'
      expect(response).to have_http_status(401)
    end

    it 'should return all the jobs' do
      user.update(user_type: 1)
      get '/api/v1/admin/jobs'
      expect(response).to have_http_status(200)
    end

    it 'should return a job with specific id' do
      user.update(user_type: 1)
      get "/api/v1/admin/jobs/#{job.id}"
      expect(response).to have_http_status(200)
    end

    it 'should not return a job if it is not found with specific id' do
      user.update(user_type: 1)
      get '/api/v1/admin/jobs/0'
      expect(response).to have_http_status(404)
    end
  end

  context 'POST - jobs' do
    let(:params) do
      {
        data: {
          attributes: {
            title: 'Backend Developer',
            organization_id: organization.id.to_s,
            skill_ids: []
          },
          type: 'jobs'
        }
      }
    end

    it 'should not create a job when user is not admin' do
      expect do
        post '/api/v1/admin/jobs', params: params.to_json, headers: HEADERS
      end.to change { Job.count }.by(0)

      expect(response).to have_http_status(401)
    end

    it 'should create a job' do
      user.update(user_type: 1)
      expect do
        post '/api/v1/admin/jobs', params: params.to_json, headers: HEADERS
      end.to change { Job.count }.by(1)

      expect(response).to have_http_status(200)
    end
  end

  context 'PUT/PATCH - jobs' do
    let(:params) do
      {
        data: {
          id: organization.id.to_s,
          attributes: {
            title: 'updated title'
          },
          type: 'jobs'
        }
      }
    end

    it 'should not update a job when user is not admin' do
      put "/api/v1/admin/jobs/#{job.id}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(401)
    end

    it 'should update a job when id is provided' do
      user.update!(user_type: 1)
      put "/api/v1/admin/jobs/#{job.id}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(200)
    end

    it 'should not update a job when it is not found' do
      params = {
        data: {
          id: '0',
          attributes: {
            title: 'updated title',
            skill_ids: []
          },
          type: 'jobs'
        }
      }

      user.update!(user_type: 1)
      put '/api/v1/admin/jobs/0', params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(404)
    end
  end

  context 'DELETE - jobs' do
    it 'should not delete job when user is not admin' do
      expect do
        delete "/api/v1/admin/jobs/#{job.id}"
      end.to change { Job.count }.by(0)

      expect(response).to have_http_status(401)
    end

    it 'should delete a job with specific id' do
      user.update(user_type: 1)
      expect do
        delete "/api/v1/admin/jobs/#{job.id}"
      end.to change { Job.count }.by(-1)

      expect(response).to have_http_status(204)
    end

    it 'should not delete a job when it is not found' do
      user.update(user_type: 1)
      expect do
        delete '/api/v1/admin/jobs/0'
      end.to change { Job.count }.by(0)

      expect(response).to have_http_status(404)
    end
  end
end
