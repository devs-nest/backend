# frozen_string_literal: true

module Api
  module V1
    # Company Resource
    class CompanyResource < JSONAPI::Resource
      attributes :id, :name, :image_url
      attributes :challenge_count

      def challenge_count
        @model&.challenges&.count || 0
      end
    end
  end
end
