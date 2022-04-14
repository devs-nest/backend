# frozen_string_literal: true

module Api
  module V1
    class CollegeFormController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth, only: %i[create]
    end
  end
end
