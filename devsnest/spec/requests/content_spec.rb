# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Content, type: :request do
  context 'Content - request specs' do
    context 'get Content' do
      let(:user) { create(:user) }
      let(:content) { create(:content) }

      it 'should return the Content if the user is logged_in' do
        sign_in(user)

        get '/api/v1/contents'
        expect(response).to have_http_status(200)
      end

      it 'should not return the Content if the user is not logged_in' do
        get '/api/v1/contents'
        expect(response).to have_http_status(401)
      end
    end
  end
end
