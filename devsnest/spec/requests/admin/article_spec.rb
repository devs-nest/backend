# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Article', type: :request do
  let(:user) { create(:user) }

  before :each do
    sign_in(user)
  end

  context 'POST - article' do
    let(:params) do
      {
        data: {
          attributes: {
            title: 'test',
            resource_type: 'blog'
          },
          type: 'articles'
        }
      }
    end

    it 'should not let user create an article when they are not admin' do
      expect do
        post '/api/v1/admin/article'
      end.to change { Article.count }.by(0)

      expect(response).to have_http_status(401)
    end

    it 'should create an article when user is admin' do
      user.update!(user_type: 1)
      expect do
        post '/api/v1/admin/article', params: params.to_json, headers: HEADERS
      end.to change { Article.count }.by(1)

      expect(response).to have_http_status(201)
    end
  end

  context 'GET - article' do
    it 'should not return the articles when user is not admin' do
      get '/api/v1/admin/article'
      expect(response).to have_http_status(401)
    end

    it 'should not return the articles when user is admin' do
      user.update!(user_type: 1)
      get '/api/v1/admin/article'
      expect(response).to have_http_status(200)
    end
  end

  context 'UPDATE - article' do
    let(:article) { create(:article, title: 'blog', resource_type: 0) }

    let(:params) do
      {
        data: {
          id: article.id,
          attributes: {
            title: 'updated blog'
          },
          type: 'articles'
        }
      }
    end

    it 'should not update an article when user is not admin' do
      put "/api/v1/admin/article/#{article.id}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(401)
    end

    it 'should not update an article if it is not found' do
      params = {
        data: {
          id: '0',
          attributes: {
            title: 'updated title'
          },
          type: 'articles'
        }
      }

      user.update!(user_type: 1)
      put '/api/v1/admin/article/0', params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(404)
    end

    it 'should update an article with given id' do
      user.update!(user_type: 1)
      put "/api/v1/admin/article/#{article.id}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(200)
    end
  end

  context 'DELETE - article' do
    let!(:article) { create(:article, title: 'blog', resource_type: 0) }

    it 'should not delete an article when user is not admin' do
      expect do
        delete "/api/v1/admin/article/#{article.id}"
      end.to change { Article.count }.by(0)

      expect(response).to have_http_status(401)
    end

    it 'should not delete an article if it is not found' do
      user.update!(user_type: 1)
      expect do
        delete '/api/v1/admin/article/0'
      end.to change { Article.count }.by(0)

      expect(response).to have_http_status(404)
    end

    it 'should delete an article with given id' do
      user.update!(user_type: 1)
      expect do
        delete "/api/v1/admin/article/#{article.id}"
      end.to change { Article.count }.by(-1)

      expect(response).to have_http_status(204)
    end
  end
end
