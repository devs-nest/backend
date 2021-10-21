# frozen_string_literal: true

# Certification Model
class Certification < ApplicationRecord
  belongs_to :user

  before_create do
    self.cuid = SecureRandom.base64(8).gsub('/', '_').gsub(/=+$/, '')
  end

  def self.type_to_description(user_id, type)
    name = User.find_by(id: user_id).name

    case type
    when 'course_dsa'
      "This is to certify that #{name} has successfully completed the Devsnest Data Structures and Algorithms Course.\n You are AWESOME!"
    when 'course_frontend'
      "This is to certify that #{name} has successfully completed the Devsnest Front-End Web Development Course.\n You are AWESOME!"
    when 'course_backend'
      "This is to certify that #{name} has successfully completed the Devsnest Back-End Web Development Course.\n You are AWESOME!"
    when 'course_dsa_frontend_backend'
      "This is to certify that #{name} has successfully completed the Devsnest DSA, Front-End and Back-End Web Development Course.\n You are AWESOME!"
    when 'community_batch_leader'
      "This certificate of appreciation is awarded to #{name} for showcasing extra ordinary leadership skills throughout the Devsnest Course. Their contribution is deeply valued by all the lives they have touched."
    when 'community_student_mentor'
      "This certificate of appreciation is awarded to #{name} for being an outstanding Student Mentor in the Devsnest Community. Their contribution is deeply valued by all the lives they have touched."
    when 'community_moderator'
      "This certificate of appreciation is awarded to #{name} for being an outstanding Community Moderator in the Devsnest Community. Their contribution is deeply valued by all the lives they have touched."
    end
  end
end
