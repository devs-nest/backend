# frozen_string_literal: true

module Api
  module V1
    class EduEventResource < JSONAPI::Resource
      attributes :title, :description, :starting_date, :ending_date, :organizer
      attributes :current_user_registered

      def current_user_registered
        user = context[:user]
        return false if user.blank?

        EventRegistration.find_by(user_id: user.id, edu_event_id: id).present?
      end
    end
  end
end
