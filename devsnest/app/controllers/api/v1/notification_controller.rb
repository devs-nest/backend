# frozen_string_literal: true

module Api
  module V1
    class NotificationController < ApplicationController
      include JSONAPI::ActsAsResourceController
    end
  end
end
