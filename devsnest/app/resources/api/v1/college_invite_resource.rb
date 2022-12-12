# frozen_string_literal: true

module Api
  module V1
    class CollegeInviteResource < JSONAPI::Resource
      attributes :email, :status, :department

      def email
        @model.college_profile.email
      end

      def department
        @model.college_profile.department
      end

      def self.records(options = {})
        super(options).where(college_id: options[:context][:college_id], department: options[:context][:department])
      end
    end
  end
end
