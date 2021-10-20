# frozen_string_literal: true

module Api
  module V1
    class CertificationResource < JSONAPI::Resource
      attributes :id, :user_id, :cuid, :created_at, :certificate_type, :title

      attributes :user_details, :description

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

      def description
        name = User.find_by(id: user_id).name
        type = certificate_type
        case type
        when 'course_dsa'
          "This is to certify that #{name} has successfully completed the module on Data Structures and Algorithms of the Devsnest Course."
        when 'course_frontend'
          "This is to certify that #{name} has successfully completed the module on Front-End Web Development of the Devsnest Course."
        when 'course_backend'
          "This is to certify that #{name} has successfully completed the module on Back-End Web Development of the Devsnest Course."
        when 'course_dsa_frontend_backend'
          "This is to certify that #{name} has successfully completed the Devsnest course on DSA, Front-End and Back-End Web Development."
        when 'community_batch_leader'
          "This certificate of appreciation is awarded to #{name} for showcasing extra ordinary leadership skills throughout the Devsnest Course."
        when 'community_student_mentor'
          "This certificate of appreciation is awarded to #{name} for being an outstanding Student Mentor in the Devsnest Community."
        when 'community_moderator'
          "This certificate of appreciation is awarded to #{name} for being an outstanding Community Moderator in the Devsnest Community."
        end
      end
    end
  end
end
