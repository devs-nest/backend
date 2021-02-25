# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ApiRenderConcern
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :validate_bot_user
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

  def validate_bot_user
    @bot = request.headers['Token'] == ENV['DISCORD_TOKEN'] && request.headers['User-Type'] == 'Bot'
    true
  end

  def user_auth
    return true if current_api_v1_user.present?

    render_forbidden
  end

  def bot_auth
    return true if @bot.present?

    render_forbidden
  end

  def simple_auth
    return true if @bot.present? || current_api_v1_user.present?

    render_forbidden
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[email password password_confirmation name discord_id])
  end
end
