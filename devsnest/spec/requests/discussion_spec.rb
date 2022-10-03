# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Discussion, type: :request do
  context 'Discussion - request specs' do
    context 'get Discussion' do
      let(:user) { create(:user) }

      it 'should return all the discussions if user is logged in' do
        sign_in(user)

        get '/api/v1/discussion'
        expect(response).to have_http_status(200)
      end
    end

    context 'delete checks for Discussion' do
      let(:user) { create(:user) }
      let(:user2) { create(:user) }
      let(:question) { create(:challenge, user_id: user.id, name: 'two sum') }
      let!(:discussion1) { create(:discussion, user_id: user.id, question_id: question.id, question_type: question.class.name) }

      it 'should delete the discussion a user have created' do
        sign_in(user)
        delete "/api/v1/discussion/#{discussion1.id}"
        expect(response).to have_http_status(204)
      end

      it 'should not delete the discussion that is created by other user (unauthorized)' do
        sign_in(user2)
        delete "/api/v1/discussion/#{discussion1.id}"
        expect(response).to have_http_status(401)
      end

      it 'should delete the discussion that is created by other user if the current user is Admin' do
        sign_in(user2)
        user2.update(user_type: 1)
        delete "/api/v1/discussion/#{discussion1.id}"
        expect(response).to have_http_status(204)
      end
    end

    context 'Upvotes and Comments checks' do
      let(:user) { create(:user) }
      let(:question) { create(:challenge, user_id: user.id, name: 'two sum') }
      let!(:discussion1) { create(:discussion, user_id: user.id, question_id: question.id, question_type: question.class.name) }
      let!(:discussion2) { create(:discussion, user_id: user.id, question_id: question.id, question_type: question.class.name, parent_id: discussion1.id) }
      let!(:upvote) { create(:upvote, user_id: user.id, content_id: discussion1.id, content_type: 'Discussion') }

      it 'should check the number of Comments for a discussion' do
        sign_in(user)
        get "/api/v1/discussion/#{discussion1.slug}"
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:upvote_count]).to eq(1)
      end

      it 'should return true as user upvoted' do
        sign_in(user)
        get "/api/v1/discussion/#{discussion1.slug}"
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:upvoted]).to eq(true)
      end

      it 'should return false as user have not upvoted' do
        sign_in(user)
        get "/api/v1/discussion/#{discussion2.slug}"
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:upvoted]).to eq(false)
      end
    end
  end
end
