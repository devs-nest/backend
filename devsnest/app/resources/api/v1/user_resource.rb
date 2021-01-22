# frozen_string_literal: true

module Api
  module V1
    class UserResource < JSONAPI::Resource
      attributes :email, :name, :password, :discord_id, :active, :role, :username, :buddy, :score
      attributes :mentor_name, :mentor_discord_id

      def mentor_name
        mentor_id = Mmt.where(user_id: @model.id).first.mentor_id          # use dig
        User.where(id: mentor_id).first.name
      end

      def mentor_discord_id
        mentor_id = Mmt.where(user_id: @model.id).first.mentor_id          # use dig
        User.where(id: mentor_id).first.discord_id
      end

      def fetchable_fields
        super - [:password]
      end
    end
  end
end
