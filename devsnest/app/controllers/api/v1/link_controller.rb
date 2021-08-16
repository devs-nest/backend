# frozen_string_literal: true

module Api
  module V1
    # link controller for urls
    class LinkController < ApplicationController
      include JSONAPI::ActsAsResourceController
    end
  end
end
