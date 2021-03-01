# frozen_string_literal: true

Rails.application.routes.draw do
  get '/health_check', to: 'health_check#index'
  # devise_for :users do
  #   collection do
  #     delete :logout
  #     post :login
  #   end
  # end

  namespace :api do
    namespace :v1 do
      jsonapi_resources :users, only: %i[index show update create] do
        collection do
          get :report, :leaderboard, :me
          delete :logout
          put :left_discord
          post :login
        end
      end
      jsonapi_resources :contents, only: %i[index show]
      jsonapi_resources :submissions, only: %i[create]
    end
  end
end

