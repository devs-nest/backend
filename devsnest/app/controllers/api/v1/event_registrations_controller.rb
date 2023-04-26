# frozen_string_literal: true

module Api
  module V1
    # Controller for Events Registrations
    class EventRegistrationsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth

      def context
        { user: @current_user }
      end

      def create
        edu_event_id = params.dig(:data, :attributes, :edu_event_id)
        user_data = params.dig(:data, :attributes, :user_data) || {}
        edu_event = EduEvent.find_by_id(edu_event_id)
        return render_not_found if edu_event.blank?

        EventRegistration.create!(user_id: @current_user.id, edu_event_id: edu_event_id, user_data: user_data)
        return render_success({ message: 'Registered Successfully.' })
      end
    end
  end
end
