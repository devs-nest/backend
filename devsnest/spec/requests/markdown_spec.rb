# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Markdown, type: :request do
  context 'Markdown - request specs' do
    context 'get Markdowns' do
      let!(:user) { create(:user) }
      let!(:markdown) { create(:markdown, template: 'नमस्ते') }
      let!(:markdown1) { create(:markdown, template: 'Software🌈 and Web developer🎯') }

      it 'should return error if User has not signed in' do
        get '/api/v1/markdown', headers: HEADERS
        expect(response.status).to eq(401)
      end

      it 'should not return error if User has signed in' do
        sign_in(user)
        get '/api/v1/markdown', headers: HEADERS
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body, symbolize_names: true)[:data].count).to eq(Markdown.all.count)
      end
    end
  end
end
