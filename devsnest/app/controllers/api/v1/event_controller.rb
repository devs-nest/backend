# frozen_string_literal: true

module Api
  module V1
    class EventController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :bot_auth, only: %i[create index]
    end
  end
end
