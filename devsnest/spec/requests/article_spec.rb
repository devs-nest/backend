# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Article', type: :request do
  context 'GET - Articles' do
    let(:article) { create(:article, title: 'blog', resource_type: 0) }

    it 'should not return the articles if the resource_type is invalid' do
      get '/api/v1/article?resource_type=asdf'
      expect(response).to have_http_status(404)
    end

    it 'should not return the articles if the resource_type is article' do
      Article.create!(title: 'test', resource_type: 1)
      get '/api/v1/article?resource_type=article'
      expect(response).to have_http_status(200)
    end

    it 'should not return the articles if the resource_type is blog' do
      Article.create!(title: 'test', resource_type: 0)
      get '/api/v1/article?resource_type=blog'
      expect(response).to have_http_status(200)
    end

    it 'returns not found when no article is found' do
      get '/api/v1/article?resource_type=article'
      expect(response).to have_http_status(404)
    end

    it 'return not found when no blog is found' do
      get '/api/v1/article?resource_type=blog'
      expect(response).to have_http_status(404)
    end

    it 'should return article when fetched by its slug' do
      get "/api/v1/article/fetch_by_slug?slug=#{article.slug}"
      expect(response).to have_http_status(200)
    end

    it 'should return not found when article is not found by its slug' do
      get '/api/v1/article/fetch_by_slug?slug=hehe'
      expect(response).to have_http_status(404)
    end

    it 'should return article when id is provided' do
      get "/api/v1/article/#{article.id}"
      expect(response).to have_http_status(200)
    end

    it 'should return not found when article is not found by its id' do
      get '/api/v1/article/0'
      expect(response).to have_http_status(404)
    end
  end

  context 'POST - create submission' do
    let(:article) { create(:article, title: 'blog', resource_type: 0) }
    let(:user) { create(:user) }

    let(:params) do
      {
        data: {
          attributes: {
            article_id: article.id.to_s
          }
        }
      }
    end

    it 'should not create submission when user is not signed in' do
      expect do
        post '/api/v1/article/create_submission', params: params.to_json
      end.to change { ArticleSubmission.count }.by(0)

      expect(response).to have_http_status(401)
    end

    it 'should create a submission when user is signed in' do
      sign_in(user)
      expect do
        post '/api/v1/article/create_submission', params: params.to_json, headers: HEADERS
      end.to change { ArticleSubmission.count }.by(1)

      expect(response).to have_http_status(200)
    end
  end
end
