# frozen_string_literal: true

Rails.application.routes.draw do
  resources :user_integrations
  get '/health_check', to: 'health_check#index'

  # Sidekiq Web UI, only for admins.
  Sidekiq::Web.use ActionDispatch::Cookies
  Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: '_interslice_session'

  Devsnest::Application.routes.draw do
    mount Sidekiq::Web => '/sidekiq'
  end

  namespace :api do
    namespace :v1 do
      # devise_for :users, :path_names => { :sign_out => 'logout', :password => 'secret', :confirmation => 'verification' } do
      #   post '/register'  => 'api/v1/registrations#create'
      # end
      devise_for :users, skip: %i[registrations]
      namespace :admin do
        jsonapi_resources :internal_feedback, only: %i[index update]
        jsonapi_resources :users, only: %i[index] do
          collection do
            post :disconnect_user
            post :support_mail
            get :check_user_details
          end
        end
        jsonapi_resources :certification, only: %i[index create update]
        jsonapi_resources :backend_challenge, only: %i[create index show update destroy] do
          collection do
            get :self_created_challenges
            get :active_questions
            post :remove_testcases
          end
        end
        jsonapi_resources :frontend_challenge, only: %i[create index show update destroy] do
          collection do
            get :self_created_challenges
            post :files_io
            get :active_questions
          end
        end
        jsonapi_resources :listmonk, only: %i[] do
          collection do
            get :list
          end
        end
        jsonapi_resources :challenge, only: %i[show index create update] do
          collection do
            get :self_created_challenges
            get :active_questions
          end
          member do
            post :add_testcase
            put :update_testcase
            get :testcases
            delete :delete_testcase
            put :update_company_tags
          end
        end
        jsonapi_resources :minibootcamp do
          collection do
            get :custom_image, to: 'minibootcamp#fetch_custom_image'
            post :custom_image, to: 'minibootcamp#upload_custom_image'
          end
        end
        jsonapi_resources :frontend_question
        jsonapi_resources :company, only: %i[index create update]
        jsonapi_resources :college_form, only: %i[index]
        jsonapi_resources :link, only: %i[index update create destroy]
        jsonapi_resources :course, only: %i[index update create destroy]
        jsonapi_resources :course_curriculum, only: %i[show index update create destroy]
        jsonapi_resources :assignment_question, only: %i[index update create destroy] do
          collection do
            post :add_assignment_questions
          end
        end
        jsonapi_resources :groups, only: %i[] do
          collection do
            post :merge_two_groups
            get :fetch_group_details
            post :assign_batch_leader
          end
        end
        jsonapi_resources :reward, only: %i[create]
        jsonapi_resources :jobs, only: %i[index create update show destroy]
        jsonapi_resources :organization, only: %i[index create update show destroy]
        jsonapi_resources :article, only: %i[index create update show destroy]
        jsonapi_resources :college_profile do
          collection do
            post :import_students
            get :dashboard_details
          end
        end
        jsonapi_resources :projects, only: %i[index create destroy]
      end
      jsonapi_resources :users, only: %i[index show update create] do
        member do
          get :get_by_username, constraints: { id: %r{[^/]+} }
          get :certifications
          post :create_github_commit
        end
        collection do
          post :register
          post :reset_password, :reset_password_initiator
          post :email_verification, :email_verification_initiator
          get :report, :leaderboard, :me, :get_token
          post :upload_i_have_enrolled_for_course_image
          put :left_discord, :update_bot_token_to_google_user, :onboard, :update_discord_username, :upload_files
          post :login, :college_login, :connect_discord, :connect_github, :create_github_repo
          delete :logout
          get :unsubscribe
          get :check_group_name
          get :check_user_details
          get :dashboard_details, :github_ping, :repo_files
          post :sourcecode_io, :disconnect_user
          post :add_repo, :remove_repo
          post :send_otp, :verify_phone_number
        end
      end

      jsonapi_resources :contents, only: %i[index show]
      jsonapi_resources :submissions, only: %i[create]
      jsonapi_resources :frontend_submissions, only: %i[create]
      jsonapi_resources :frontend_questions, only: %i[show]
      jsonapi_resources :user_skill, only: %i[index create]
      jsonapi_resources :groups, only: %i[show index create update] do
        jsonapi_relationships
        collection do
          get :server_details
          get :team_details
          delete :delete_group
          put :update_group_name, :update_batch_leader
          post :promote, :join
          get :weekly_group_data
        end
        member do
          post :leave
        end
      end
      jsonapi_resources :group_members, only: %i[index show destroy] do
        collection do
          post :update_user_group
        end
      end
      jsonapi_resources :college, only: %i[create show] do
        collection do
          post :invite, :join, :structure
          get :structure_schema
        end
      end
      jsonapi_resources :college_invite, only: %i[index]
      jsonapi_resources :college_profile, only: %i[index]
      jsonapi_resources :scrums, only: %i[create index update] do
        collection do
          get :weekly_leaderboard
        end
      end
      jsonapi_resources :weekly_todo, only: %i[create index update] do
        member do
          get :streak
        end
      end
      jsonapi_resources :batch_leader_sheet, only: %i[create index update]
      jsonapi_resources :markdown, only: %i[index]
      jsonapi_resources :minibootcamp, only: %i[show index] do
        collection do
          get :menu
          get :predefined_templates
        end
      end
      jsonapi_resources :minibootcamp_submissions, only: %i[show index create update]
      jsonapi_resources :frontend_questions, only: %i[show]
      jsonapi_resources :internal_feedback, only: %i[create index]
      jsonapi_resources :link, only: %i[show]
      jsonapi_resources :hackathon, only: %i[create index update show]
      jsonapi_resources :notification_bot, only: %i[index update show] do
        member do
          get :change_token
        end
      end
      jsonapi_resources :notification, only: %i[create index]
      jsonapi_resources :event, only: %i[create index]
      jsonapi_resources :challenge, only: %i[index show] do
        collection do
          get '/:id/submissions', to: 'challenge#submissions'
          get :fetch_by_slug
          get :leaderboard
          get :next_question
        end
        member do
          get :companies
          get :submissions
          get :template
        end
      end
      jsonapi_resources :language, only: %i[index]
      jsonapi_resources :algo_submission, only: %i[create show update] do
        collection do
          put :callback
        end
      end
      jsonapi_resources :run_submission, only: %i[show update] do
        collection do
          put :callback
        end
      end
      jsonapi_resources :certification, only: %i[show]
      jsonapi_resources :frontend_project, only: %i[show index create update destroy]
      jsonapi_resources :company, only: %i[index create]
      jsonapi_resources :discussion, only: %i[show index create destroy]
      jsonapi_resources :upvote, only: %i[create destroy]
      jsonapi_resources :college_form, only: %i[create]
      jsonapi_resources :course_curriculum, only: %i[show index]
      jsonapi_resources :referral, only: %i[index]
      jsonapi_resources :server_users, only: %i[create]
      jsonapi_resources :frontend_challenge, only: %i[index show] do
        collection do
          get :fetch_by_slug
          get :fetch_frontend_testcases
        end
      end
      jsonapi_resources :fe_submissions, only: %i[create show index]
      jsonapi_resources :coin_logs, only: %i[index]
      jsonapi_resources :jobs, only: %i[index show] do
        collection do
          get :fetch_by_slug
        end
      end
      jsonapi_resources :job_applications, only: %i[create show index update]
      jsonapi_resources :skill, only: %i[index create destroy]
      jsonapi_resources :organization, only: %i[index show] do
        collection do
          get :fetch_by_slug
        end
      end
      jsonapi_resources :be_submissions, only: %i[create show index]
      jsonapi_resources :backend_challenge, only: %i[index show] do
        collection do
          get :fetch_by_slug
        end
      end
      jsonapi_resources :article, only: %i[index show] do
        collection do
          get :fetch_by_slug
          post :create_submission
        end
      end
      jsonapi_resources :article_submissions, only: %i[create show]
      jsonapi_resources :bootcamp_progresses, only: %i[create index] do
        collection do
          post :complete_day
        end
      end
      jsonapi_resources :user_integration, only: %i[] do
        collection do
          put :update_links
          get :links, :leetcode, :gfg, :hackerrank, :github_data
        end
      end
      jsonapi_resources :coding_rooms, only: %i[index create show] do
        collection do
          get :leaderboard
          post :join_room
          put :leave_room
          put :start_room
          get :current_user_room
        end
        member do
          get :user_submissions
          get :active_user_list
          put :update_room_details
        end
      end
      jsonapi_resources :projects, only: %i[index] do
        collection do
          get :completed
        end
      end
      jsonapi_resources :edu_events, only: %i[show index]
      jsonapi_resources :event_registrations, only: :create
      jsonapi_resources :college_students, only: %i[show] do
        collection do
          put :verify_phone
          put :personal_details
          put :education_details
          put :preview
        end
      end
      jsonapi_resources :orders, only: %i[create] do
        collection do
          post :verify_payment
        end
      end
    end
  end
end
