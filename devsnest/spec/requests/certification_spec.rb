# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Certification', type: :request do
  let(:user) { create(:user) }
  before :each do
    sign_in(user)
  end

  context 'Certification - DSA course check' do
    let(:certificate) { create(:certification, cuid: SecureRandom.base64(10).gsub('/', '_').gsub(/=+$/, ''), certificate_type: 'course_dsa', user_id: user.id) }
    it 'Dsa course case' do
      get "/api/v1/certification/#{certificate.cuid}"
      description = Certification.type_to_description(user.id, certificate.certificate_type)
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['attributes']['cuid']).to eq(certificate.cuid)
      expect(JSON.parse(response.body)['data']['attributes']['user_details']['name']).to eq(user.name)
      expect(JSON.parse(response.body)['data']['attributes']['user_details']['username']).to eq(user.username)
      expect(JSON.parse(response.body)['data']['attributes']['description']).to eq(description)
    end
  end

  context 'Certification - Frontend course check' do
    let(:certificate) { create(:certification, cuid: SecureRandom.base64(10).gsub('/', '_').gsub(/=+$/, ''), certificate_type: 'course_frontend', user_id: user.id) }
    it 'Frontend course case' do
      get "/api/v1/certification/#{certificate.cuid}"
      description = Certification.type_to_description(user.id, certificate.certificate_type)
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['attributes']['cuid']).to eq(certificate.cuid)
      expect(JSON.parse(response.body)['data']['attributes']['user_details']['name']).to eq(user.name)
      expect(JSON.parse(response.body)['data']['attributes']['user_details']['username']).to eq(user.username)
      expect(JSON.parse(response.body)['data']['attributes']['description']).to eq(description)
    end
  end

  context 'Certification - backend course check' do
    let(:certificate) { create(:certification, cuid: SecureRandom.base64(10).gsub('/', '_').gsub(/=+$/, ''), certificate_type: 'course_backend', user_id: user.id) }
    it 'backend course case' do
      get "/api/v1/certification/#{certificate.cuid}"
      description = Certification.type_to_description(user.id, certificate.certificate_type)
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['attributes']['cuid']).to eq(certificate.cuid)
      expect(JSON.parse(response.body)['data']['attributes']['user_details']['name']).to eq(user.name)
      expect(JSON.parse(response.body)['data']['attributes']['user_details']['username']).to eq(user.username)
      expect(JSON.parse(response.body)['data']['attributes']['description']).to eq(description)
    end
  end

  context 'Certification - Full course check' do
    let(:certificate) { create(:certification, cuid: SecureRandom.base64(10).gsub('/', '_').gsub(/=+$/, ''), certificate_type: 'course_dsa_frontend_backend', user_id: user.id) }
    it 'Full course case' do
      get "/api/v1/certification/#{certificate.cuid}"
      description = Certification.type_to_description(user.id, certificate.certificate_type)
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['attributes']['cuid']).to eq(certificate.cuid)
      expect(JSON.parse(response.body)['data']['attributes']['user_details']['name']).to eq(user.name)
      expect(JSON.parse(response.body)['data']['attributes']['user_details']['username']).to eq(user.username)
      expect(JSON.parse(response.body)['data']['attributes']['description']).to eq(description)
    end
  end

  context 'Certification - community_batch_leader check' do
    let(:certificate) { create(:certification, cuid: SecureRandom.base64(10).gsub('/', '_').gsub(/=+$/, ''), certificate_type: 'community_batch_leader', user_id: user.id) }
    it 'community_batch_leader case' do
      get "/api/v1/certification/#{certificate.cuid}"
      description = Certification.type_to_description(user.id, certificate.certificate_type)
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['attributes']['cuid']).to eq(certificate.cuid)
      expect(JSON.parse(response.body)['data']['attributes']['user_details']['name']).to eq(user.name)
      expect(JSON.parse(response.body)['data']['attributes']['user_details']['username']).to eq(user.username)
      expect(JSON.parse(response.body)['data']['attributes']['description']).to eq(description)
    end
  end

  context 'Certification - community_student_mentor check' do
    let(:certificate) { create(:certification, cuid: SecureRandom.base64(10).gsub('/', '_').gsub(/=+$/, ''), certificate_type: 'community_student_mentor', user_id: user.id) }
    it 'community_student_mentor case' do
      get "/api/v1/certification/#{certificate.cuid}"
      description = Certification.type_to_description(user.id, certificate.certificate_type)
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['attributes']['cuid']).to eq(certificate.cuid)
      expect(JSON.parse(response.body)['data']['attributes']['user_details']['name']).to eq(user.name)
      expect(JSON.parse(response.body)['data']['attributes']['user_details']['username']).to eq(user.username)
      expect(JSON.parse(response.body)['data']['attributes']['description']).to eq(description)
    end
  end

  context 'Certification - community_moderator check' do
    let(:certificate) { create(:certification, cuid: SecureRandom.base64(10).gsub('/', '_').gsub(/=+$/, ''), certificate_type: 'community_moderator', user_id: user.id) }
    it 'community_moderator case' do
      get "/api/v1/certification/#{certificate.cuid}"
      description = Certification.type_to_description(user.id, certificate.certificate_type)
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['attributes']['cuid']).to eq(certificate.cuid)
      expect(JSON.parse(response.body)['data']['attributes']['user_details']['name']).to eq(user.name)
      expect(JSON.parse(response.body)['data']['attributes']['user_details']['username']).to eq(user.username)
      expect(JSON.parse(response.body)['data']['attributes']['description']).to eq(description)
    end
  end
end
