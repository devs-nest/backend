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
