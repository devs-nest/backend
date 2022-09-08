# frozen_string_literal: true

module Api
  module V1
    # FE submission controller
    class FeSubmissionsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth, only: %i[show index]
      before_action :current_user_auth, only: %i[create]
      # before_action :callback_auth, only: %i[create] #TODO
    end
  end
end
