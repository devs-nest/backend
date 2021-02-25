# frozen_string_literal: true

module Api
  module V1
    class ContentsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :simple_auth, only: %i[index show]
    end
  end
end
