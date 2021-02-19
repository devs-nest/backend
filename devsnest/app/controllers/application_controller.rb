# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ApiRenderConcern
  before_action :authenticate_user! 
  def render_resource(resource)
    if resource.errors.empty?
      render json: resource
    else
      validation_error(resource)
    end
  end

  def validation_error(resource)
    render json: {
      errors: [
        {
          status: '400',
          title: 'Bad Request',
          detail: resource.errors,
          code: '100'
        }
      ]
    }, status: :bad_request
  end

      def context
        { user: current_user }
      end

  # def after_sign_in_path_for(resource)
  #   byebug
  #   if current_user.discord_id == ""
  #     redirect_to_discord_id_update_page
  #   else
  #     redirect_to_root
  #   end
  #   #user_path(current_user) # your path
  #   end

  def discord_authorize
    return render_forbidden if current_user.discord_id == ""
    #or redirect to update page if discord_id is null
  end
end
