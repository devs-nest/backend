# frozen_string_literal: true

module Api
  module V1
    module Admin
      # AssignmentQuestion Controller for Admin
      class AssignmentQuestionController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth
      end
    end
  end
end
