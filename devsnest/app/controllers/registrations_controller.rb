# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  respond_to :json

   # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    super
  end
end
