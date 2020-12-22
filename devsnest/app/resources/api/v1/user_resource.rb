# frozen_string_literal: true

module Api
  module V1
    class UserResource < JSONAPI::Resource
      attributes :email, :name, :kind, :bio, :image_url, :password

      def self.updatable_fields(context)
        if context[:user].normal?
          super - [:kind]
        else
          super
        end
      end

      def self.creatable_fields(context)
        if context[:user].normal?
          super - [:kind]
        else
          super
        end
      end
    end
  end
end
