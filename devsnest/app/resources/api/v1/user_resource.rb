# frozen_string_literal: true

module Api
  module V1
    class UserResource < JSONAPI::Resource
      attributes :email, :name, :password, :discord_id, :discord_active, :role, :username, :buddy, :score, :web_active
      attributes :mentor_name, :mentor_discord_id

      def mentor_name
        mentor = Mmt.where(user_id: @model.id).first
        mentor.present? ? User.where(id: mentor.mentor_id).first.name : nil
      end

      def mentor_discord_id
        mentor = Mmt.where(user_id: @model.id).first
        mentor.present? ? User.where(id: mentor.mentor_id).first.discord_id : nil
      end


      def fetchable_fields
        super - [:password]
      end
    end
  end
end
