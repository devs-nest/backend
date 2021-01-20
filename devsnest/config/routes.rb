# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users,
             path: '',
             path_names: {
               registration: 'signup'
             },
             controllers: {
               registrations: 'registrations',
               omniauth_callbacks: 'omniauth_callbacks'
             }

  namespace :api do
    namespace :v1 do
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
