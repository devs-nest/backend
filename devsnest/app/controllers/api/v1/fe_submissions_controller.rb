# frozen_string_literal: true

module Api
  module V1
    # FE submission controller
    class FeSubmissionsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :github_auth, only: %i[create]
      before_action :user_auth, only: %i[show index]
    end
  end
end
