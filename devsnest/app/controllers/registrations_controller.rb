# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    build_resource(sign_up_params)

    resource.save
    render_resource(resource)
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :name,:discord_id)
  end
end
