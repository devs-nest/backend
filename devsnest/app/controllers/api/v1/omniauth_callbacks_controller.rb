# frozen_string_literal: true

# This is oauth controller to handle discord_login
module Api
  module V1
    class OmniauthCallbacksController < Devise::OmniauthCallbacksController
      # redirect user not to root but to a specific page
      def discord
        user = User.find_for_discord(request.env['omniauth.auth'])
        if user.persisted?
          sign_in_and_redirect user, event: :authentication
        else
          render 'There was an error while trying to authenticate you...'
        end
      end
    end
  end
end
