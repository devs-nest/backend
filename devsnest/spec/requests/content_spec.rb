# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Content, type: :request do
  context 'Content - request specs' do
    context 'get Content' do
      let(:user) { create(:user) }
      let(:content) { create(:content) }
      let(:content2) { create(:content) }
      let(:submission1) { create(:submission, user: user.id, content: content2.id) }
      let(:submission1) { create(:submission, user: user.id, content: content2.id, status: 1) }
      let(:frontendsubmission1) { create(:frontendsubmission, user: user.id, content: content2.id) }

      it 'should return the Content if the user is logged_in' do
        sign_in(user)

        get '/api/v1/contents'
        expect(response).to have_http_status(200)
      end

      it 'should not return the Content if the user is not logged_in' do
        get '/api/v1/contents'
        expect(response).to have_http_status(401)
      end

      it 'should not return list of video questions' do
        sign_in(user)
        content.update(video_questions: [content2.id])
        get '/api/v1/contents'
        expect(response).to have_http_status(200)
      end
    end
  end
end
