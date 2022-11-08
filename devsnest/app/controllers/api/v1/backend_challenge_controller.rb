# frozen_string_literal: true

module Api
  module V1
    # api for backend challenge
    class BackendChallengeController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth, only: %i[index show]
    end
  end
end
