# frozen_string_literal: true

module Api
  module V1
    # Minibootcamp Cotroller
    class MinibootcampController < ApplicationController
      include JSONAPI::ActsAsResourceController
    end
  end
end
