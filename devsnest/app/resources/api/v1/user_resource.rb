# frozen_string_literal: true

module Api
  module V1
    class UserResource < JSONAPI::Resource
      attributes :email, :name, :password, :discord_id, :web_active, :username, :score, :discord_active

      def fetchable_fields
        if context[:user].nil? || context[:user].id == @model.id
          super - [:password]
        else
          super - [:password, :email]
        end
      end
    end
  end
end
