# frozen_string_literal: true

module Api
  module V1
    # Minibootcamp Cotroller
    class MinibootcampController < ApplicationController
      include JSONAPI::ActsAsResourceController

      def context
        {
          parent_id: params.dig("filter", "parent_id")
        }
      end
    end
  end
end
