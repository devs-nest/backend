# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Resource
      class CertificationResource < JSONAPI::Resource
        attributes :id, :user_id, :cuid, :created_at, :certificate_type, :title

        attributes :user_details, :description

        def user_details
          user = User.find_by(id: user_id)
          return {} if user.nil?

          { name: user.name, username: user.username }
        end

        def description
          Certification.type_to_description(user_id, certificate_type)
        end
      end
    end
  end
end
