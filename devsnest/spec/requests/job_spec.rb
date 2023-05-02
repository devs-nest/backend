# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Job', type: :request do
  context 'GET - Jobs' do
    let(:user) { create(:user) }
    let(:organization) { create(:organization) }
    let(:job) { create(:job, title: 'Spec Job', organization_id: organization.id) }

    before :each do
      sign_in(user)
    end

    it 'should not return the jobs when user is not authenticated' do
      sign_out(user)
      get '/api/v1/jobs'
      expect(response).to have_http_status(401)
    end

    it 'should return all the jobs' do
      get '/api/v1/jobs'
      expect(response).to have_http_status(200)
    end

    it 'should return a job when id is provided' do
      get "/api/v1/jobs/#{job.id}"
      expect(response).to have_http_status(200)
    end

    it 'should not return a job when job is not found with specific id' do
      get '/api/v1/jobs/0'
      expect(response).to have_http_status(404)
    end
  end
end
