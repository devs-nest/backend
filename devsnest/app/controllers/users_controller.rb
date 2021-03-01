# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :user_auth, only: [:log_out]

  def logout
    reset_session
    render json: { notice: 'You logged out successfuly' }
  end

  def login
    # code = params['code']
    user = User.first
    # User.fetch_discord_user(code)
    byebug
    if user
      sign_in(user)

    else
      return render_forbidden
    end
    render json: { notice: 'You are logged in correctly' }
  end
end

