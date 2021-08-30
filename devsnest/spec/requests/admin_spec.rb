# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::AdminController, type: :request do
  context 'Onboard Details with an authenticated user' do
    let(:user) { create(:user, user_type: 1) } # admin
    let(:user2) { create(:user, user_type: 0) }
    let(:controller) { Api::V1::AdminController }

    before :each do
      sign_in(user)
    end

    it 'renders csv plain format' do
      get '/api/v1/admin/onboard_details'
      expect(response.status).to eq(200)
      expect(response.body).to eq("id,discord_username,discord_id,name,grad_year,school,work_exp,known_from,dsa_skill,webd_skill\n")
      expect(headers['Content-Type'].split[0]).to eq('text/csv;')
      expect(headers['Content-Disposition']).to eq("attachment; filename=onboard_results_#{Date.current}.csv")
    end

    it 'checks for users with filled forms' do
      user1 = create(:user, is_discord_form_filled: true, discord_username: 'u1', grad_year: 3, dsa_skill: 3, known_from: 'Friend')
      create(:user, is_discord_form_filled: false, discord_username: 'u2', grad_year: 4, dsa_skill: 2, known_from: 'Linkedin')

      get '/api/v1/admin/onboard_details'
      expect(response.status).to eq(200)
      expect(response.body).to eq("id,discord_username,discord_id,name,grad_year,school,work_exp,known_from,dsa_skill,webd_skill\n#{user1.id},u1,#{user1.discord_id},#{user1.name},3,,,Friend,3,0\n")
      expect(headers['Content-Type'].split[0]).to eq('text/csv;')
      expect(headers['Content-Disposition']).to eq("attachment; filename=onboard_results_#{Date.current}.csv")
    end

    it 'check for the data that was created 15 days ago' do
      create(:user, is_discord_form_filled: true, discord_username: 'u1', grad_year: 3, dsa_skill: 3, known_from: 'Friend', created_at: Date.today - 15)
      user2 = create(:user, is_discord_form_filled: true, discord_username: 'u2', grad_year: 4, dsa_skill: 2, known_from: 'Linkedin', created_at: Date.today - 10)

      get '/api/v1/admin/onboard_details'
      expect(response.status).to eq(200)
      expect(response.body).to eq("id,discord_username,discord_id,name,grad_year,school,work_exp,known_from,dsa_skill,webd_skill\n#{user2.id},u2,#{user2.discord_id},#{user2.name},4,,,Linkedin,2,0\n")
      expect(headers['Content-Type'].split[0]).to eq('text/csv;')
      expect(headers['Content-Disposition']).to eq("attachment; filename=onboard_results_#{Date.current}.csv")
    end

    it 'checks for non admin users' do
      sign_in(user2)
      get '/api/v1/admin/onboard_details'
      expect(response.status).to eq(401)
    end
  end

  context 'Feedback Details with an authenticated user' do
    let(:user) { create(:user, user_type: 1) } # admin
    let(:user2) { create(:user, user_type: 0) }
    let(:controller) { Api::V1::AdminController }

    before :each do
      sign_in(user)
    end

    it 'renders csv plain format' do
      get '/api/v1/admin/feedback_details'
      expect(response.status).to eq(200)
      expect(response.body).to eq("id,user_id,user_name,issue_type,issue_described,feedback,issue_scale\n")
      expect(headers['Content-Type'].split[0]).to eq('text/csv;')
    end

    it 'checks for non admin users' do
      sign_in(user2)
      get '/api/v1/admin/feedback_details'
      expect(response.status).to eq(401)
    end
  end
end
