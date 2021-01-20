# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users,
             path: '',
             path_names: {
               sign_in: 'login',
               sign_out: 'logout',
               registration: 'signup'
             },
             controllers: {
               sessions: 'sessions',
               registrations: 'registrations'
             }

  namespace :api do
    namespace :v1 do
      jsonapi_resources :users do
        collection do
          get :leaderboard
        end
      end
      jsonapi_resources :users
      jsonapi_resources :mmts
      jsonapi_resources :mentor_feedbacks
      jsonapi_resources :mentee_feedbacks
      jsonapi_resources :writeups, only: :create
      jsonapi_resources :contents, only: %i[index show]
      jsonapi_resources :submissions, only: %i[create]
    end
  end
end
