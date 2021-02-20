# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ApiRenderConcern
  before_action :configure_permitted_parameters, if: :devise_controller?
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

  # def after_sign_in_path_for(resource)
  #   if current_user.discord_id == ""
  #     redirect_to_api_v1_users
  #   else
  #     redirect_to_root
  #   end
  #   #user_path(current_user) # your path
  #   end

  def discord_authorize
    return render_forbidden if current_user.discord_id == ""
    #or redirect to update page if discord_id is null
  end
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :name, :discord_id])
  end
end
