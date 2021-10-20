# frozen_string_literal: true

module Api
  module V1
    class CertificationResource < JSONAPI::Resource
      attributes :id, :user_id, :title, :cuid, :description, :created_at, :certificate_type

      attributes :user_details

      def user_details
        user = User.find_by(id: user_id)

        if user.present?
          {
            name: user.name,
            username: user.username
          }
        else
          {}
        end
      end
    end
  end
end
