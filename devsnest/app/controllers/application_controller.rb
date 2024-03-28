# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ApiRenderConcern
  include UtilConcern
  before_action :set_current_tenant
  before_action :set_current_user
  before_action :validate_bot_user
  before_action :initialize_redis_lb
  before_action :set_paper_trail_whodunnit

  # def default_url_options
  #   if Rails.env.production?
  #     {:host => "api.devsnest.in"}
  #   else
  #     {}
  #   end
  # end

  def set_current_tenant
    subdomain = request.subdomain
    origin = request.origin
    @current_tenant = Tenant.find_by(subdomain: subdomain)
    Rails.logger.info "current subdomain: #{subdomain}"
    Rails.logger.info "origin: #{origin}"
    return render_not_found if @current_tenant.nil?
  end

  def user_for_paper_trail
    @current_user ? @current_user.id : 'Public user'
  end

  def paper_trail_enabled_for_controller
    # Don't omit `super` without a good reason.
    super && request.user_agent != 'Disable User-Agent' && current_api_v1_user&.user_type != 'user'
  end

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
    # @current_user = User.find(1) ADHIKRAM BHAIYA OP
    return true if @current_user.present?

    render_unauthorized
  end

  def current_user_auth
    user_id = request.params.dig('data', 'attributes', 'user_id')
    return true if @current_user.present? && @current_user.id == user_id

    render_unauthorized
  end

  def callback_auth
    user = User.find_by_id(request.params.dig('data', 'attributes', 'user_id'))
    return render_not_found if user.nil?
    return true if request.headers['Token'] == user.bot_token

    render_unauthorized
  end

  def bot_auth
    return true if @bot.present?

    render_unauthorized
  end

  def simple_auth
    return true if @bot.present? || @current_user.present?

    render_unauthorized
  end

  def set_college
    Rails.logger.info(params)
    @college = if params[:id].present?
      College.find_by(slug: params[:id])
               elsif params[:college_id].present?
                 College.find_by(id: params[:college_id])
               end

    return true if @college.present?

    render_unauthorized
  end

  def college_admin_auth
    @college_profile = CollegeProfile.find_by(user_id: @current_user.try(:id), college_id: @college.try(:id), authority_level: 'superadmin')
    return true if @current_user.is_admin? || @college_profile.present?

    render_unauthorized
  end

  def check_college_verification
    return true if @college.is_verified

    render_unauthorized('College is not verified, we are on it.')
  end

  def set_current_user
    @current_user = nil
    @current_user = current_api_v1_user if current_api_v1_user.present?
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[email password password_confirmation name discord_id])
  end

  def check_username(username)
    username.match(/^(?!.*\.\.)(?!.*\.$)[^\W][\w.]{4,29}$/).nil?
  end

  def admin_auth
    return true if @current_user.present? && @current_user.user_type == 'admin'

    render_unauthorized
  end

  def problem_setter_auth
    return true if @current_user.present? && (@current_user.user_type == 'admin' || @current_user.user_type == 'problem_setter')

    render_unauthorized
  end

  def initialize_redis_lb
    @dsa_leaderboard ||= LeaderboardDevsnest::DSAInitializer::LB
    @fe_leaderboard ||= LeaderboardDevsnest::FEInitializer::LB
  end
end
