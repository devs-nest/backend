# frozen_string_literal: true

module Api
  module V1
    # Hackathon Controller
    class HackathonController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth
      before_action :admin_auth, only: %i[update create]
    end
  end
end
