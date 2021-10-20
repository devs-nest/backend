# frozen_string_literal: true

# Certification Model
class Certification < ApplicationRecord
  belongs_to :user

  before_create do
    self.cuid = SecureRandom.base64(8).gsub('/', '_').gsub(/=+$/, '')
  end

  # enum certificate_type: %i[course_dsa course_frontend course_backend course_dsa_frontend_backend community_batch_leader community_student_mentor community_moderator]
end
