# frozen_string_literal: true

module Api
  module V1
    # BE submission controller
    class BeSubmissionsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth, only: %i[show index]
      before_action :current_user_auth, only: %i[create]
    end
  end
end
