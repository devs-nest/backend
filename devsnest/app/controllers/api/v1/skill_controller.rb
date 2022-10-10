# frozen_string_literal: true

module Api
  module V1
    class SkillController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :admin_auth, only: %i[create update destroy]
    end
  end
end
