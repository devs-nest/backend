# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Resource
      class CertificationResource < JSONAPI::Resource
        attributes :id, :user_id, :certificate_type

        attributes :user_details, :title
        paginator :paged

        def user_details
          user = User.find_by(id: user_id)
          return {} if user.nil?

          { name: user.name, username: user.username }
        end

        def title
          Certification.type_to_title(certificate_type)
        end
      end
    end
  end
end
