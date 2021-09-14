# frozen_string_literal: true

Rails.application.routes.draw do
  get '/health_check', to: 'health_check#index'
  namespace :api do
    namespace :v1 do
      devise_for :users, skip: [:registrations]
      jsonapi_resources :users, only: %i[index show update create] do
        member do
          get :get_by_username
        end
        collection do
          get :report, :leaderboard, :me, :get_token
          put :left_discord, :update_bot_token_to_google_user, :onboard, :update_discord_username
          post :login, :connect_discord
          delete :logout
        end
      end

      jsonapi_resources :contents, only: %i[index show]
      jsonapi_resources :submissions, only: %i[create]
      jsonapi_resources :frontend_submissions, only: %i[create]
      jsonapi_resources :groups, only: %i[show index] do
        jsonapi_relationships
        collection do
          delete :delete_group
          put :update_group_name, :update_batch_leader
        end
      end
      jsonapi_resources :group_members, only: %i[index show] do
        collection do
          post :update_user_group
        end
      end
      jsonapi_resources :college, only: %i[index]
      jsonapi_resources :scrums, only: %i[create index update]
      jsonapi_resources :weekly_todo, only: %i[create index update] do
        member do
          get :streak
        end
      end
      jsonapi_resources :batch_leader_sheet, only: %i[create index update]
      jsonapi_resources :markdown, only: %i[index]
      resources :admin, only: %i[] do
        collection do
          get :onboard_details, :feedback_details
        end
      end
      jsonapi_resources :internal_feedback, only: %i[create update]
      jsonapi_resources :link, only: %i[show]
      jsonapi_resources :hackathon, only: %i[create index update show]
      jsonapi_resources :notification_bot, only: %i[create index]
      jsonapi_resources :notification, only: %i[create index]
      jsonapi_resources :event, only: %i[create index]
    end
  end
end
