# frozen_string_literal: true

module Api
  module V1
    # Company Resource
    class CompanyResource < JSONAPI::Resource
      caching
      attributes :name, :image_url
      attributes :challenge_count

      def challenge_count
        @model&.challenges&.where(is_active: true)&.count || 0
      end
    end
  end
end
