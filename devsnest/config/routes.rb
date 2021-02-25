# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      devise_for :users,
                 controllers: {
                   registrations: 'api/v1/registrations',
                   omniauth_callbacks: 'api/v1/omniauth_callbacks'
                 }
      jsonapi_resources :users, only: %i[index show update create] do
        collection do
          get :report, :leaderboard
          delete :log_out
          put :left_discord
        end
      end
      jsonapi_resources :contents, only: %i[index show]
      jsonapi_resources :submissions, only: %i[create]
    end
  end
end

