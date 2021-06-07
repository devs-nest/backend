# frozen_string_literal: true

Rails.application.routes.draw do
  get '/health_check', to: 'health_check#index'
  namespace :api do
    namespace :v1 do
      devise_for :users, skip: [:registrations]
      jsonapi_resources :users, only: %i[index show update create] do
        collection do
          get :report, :leaderboard, :me, :get_token
          put :left_discord
          post :login, :connect_discord
          delete :logout
        end
      end
      jsonapi_resources :contents, only: %i[index show]
      jsonapi_resources :submissions, only: %i[create]
      jsonapi_resources :groups, only: %i[show]
      jsonapi_resources :group_members, only: %i[index show]
      jsonapi_resources :college, only: %i[index]
    end
  end
end
