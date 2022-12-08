# frozen_string_literal: true

module Api
  module V1
    # College Profile Resource
    class CollegeProfileResource < JSONAPI::Resource
      attributes :name, :email, :department, :authority_level

      def name
        @model.user&.name
      end

      def self.records(options = {})
        super(options).where(college_id: options[:context][:college_id]).where.not(user_id: nil)
      end
    end
  end
end
