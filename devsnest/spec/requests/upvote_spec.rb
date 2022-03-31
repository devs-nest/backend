# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Upvote, type: :request do
  context 'Upvote - request specs' do
    context 'get Discussion' do
      let(:user) { create(:user) }
      let(:user2) { create(:user) }
      let(:question) { create(:challenge, user_id: user.id, name: 'two sum') }
      let!(:discussion1) { create(:discussion, user_id: user.id, challenge_id: question.id) }

      it 'should upvote a discussion that is done by user' do
        sign_in(user)

        post '/api/v1/upvote', params: {
          "data": {
            "attributes": {
              "user_id": user.id,
              "content_id": discussion1.id,
              "content_type": 'Discussion'
            },
            "type": 'upvotes'
          }
        }.to_json, headers: HEADERS
        expect(response).to have_http_status(201)
      end

      it 'should not create an upvote if an user have already upvoted' do
        Upvote.create(user_id: user.id, content_id: discussion1.id, content_type: 'Discussion')
        sign_in(user)

        post '/api/v1/upvote', params: {
          "data": {
            "attributes": {
              "user_id": user.id,
              "content_id": discussion1.id,
              "content_type": 'Discussion'
            },
            "type": 'upvotes'
          }
        }.to_json, headers: HEADERS
        expect(response).to have_http_status(422)
      end

      it 'should not delete an upvote if done by other user' do
        upvote = Upvote.create(user_id: user.id, content_id: discussion1.id, content_type: 'Discussion')
        sign_in(user2)

        delete "/api/v1/upvote/#{upvote.id}"
        expect(response).to have_http_status(401)
      end

      it 'should delete an upvote if done by its user' do
        upvote = Upvote.create(user_id: user.id, content_id: discussion1.id, content_type: 'Discussion')
        sign_in(user)

        delete "/api/v1/upvote/#{upvote.id}"
        expect(response).to have_http_status(204)
      end
    end
  end
end
