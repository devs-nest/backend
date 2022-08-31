# frozen_string_literal: true

module Api
  module V1
    class CoinLogResource < JSONAPI::Resource
      attributes :user_id, :pointable_type, :coins, :title, :description
      filter :user_id

      def title
        @model.pointable.title
      end

      def description
        @model.pointable.description
      end
    end
  end
end
