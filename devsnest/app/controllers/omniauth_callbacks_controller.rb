# frozen_string_literal: true

class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    user = User.find_for_google_oauth2(request.env['omniauth.auth'], current_user)
    if user.persisted?
      sign_in_and_redirect user, event: :authentication
    else
      render 'There was an error while trying to authenticate you...'
    end
  end
end
