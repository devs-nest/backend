# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Minibootcamp Controller
      class MinibootcampController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth
      end
    end
  end
end
