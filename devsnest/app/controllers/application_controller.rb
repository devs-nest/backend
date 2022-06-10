# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ApiRenderConcern
  before_action :set_current_user
  before_action :validate_bot_user
  before_action :initialize_redis_lb
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
    return true if @current_user.present?

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
    @leaderboard ||= LeaderboardDevsnest::Initializer::LB
  end

  def group_guild_id(role_name, server_guild_id = ENV['DISCORD_GUILD_ID'])
    group = Group.find_by(name: role_name)
    if server_guild_id.present?
      server_guild_id
    elsif group.present?
      group.server.guild_id
    end
  end

  def user_group(discord_id)
    user = User.find_by(discord_id: discord_id)
    if user.present?
      groupmember = GroupMember.find_by(user_id: user.id)
      return 'No group found' if groupmember.nil?

      groupmember.group
    else
      'No user found'
    end
  end
end
