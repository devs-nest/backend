# frozen_string_literal: true

# == Schema Information
#
# Table name: certifications
#
#  id               :bigint           not null, primary key
#  certificate_type :string(255)
#  cuid             :string(255)      default("GIsnLwSP52E")
#  title            :string(255)      default("")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer
#
# Indexes
#
#  index_certificates_on_user_id_and_certificate_type  (user_id,certificate_type) UNIQUE
#
class Certification < ApplicationRecord
  validates_uniqueness_of :cuid, case_sensitive: true
  belongs_to :user

  before_create do
    self.cuid = SecureRandom.base64(8).gsub('/', '_').gsub(/=+$/, '')
  end

  def self.type_to_title(type)
    type_title_hashmap = {
      'course_dsa': 'DSA Course',
      'course_frontend': 'Frontend Course',
      'course_backend': 'Backend Course',
      'course_dsa_frontend_backend': 'Devsnest Course',
      'community_batch_leader': 'Batch Lead',
      'community_student_mentor': 'Student Mentor',
      'community_moderator': 'Community Moderator',
      'course_solana': 'Devsnest Solana Bootcamp'
    }

    type_title_hashmap[type.to_sym]
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
    when 'course_solana'
      "This is to certify that #{name} has successfully completed the Devsnest Solana Bootcamp.\n You are AWESOME!"
    end
  end

  def self.make_certifications(certification_file)
    invalid_discord_ids = []
    CSV.foreach(certification_file, headers: true) do |row|
      certificate_type = row['certificate_type']
      user = User.find_by(discord_id: row['discord_id'])
      begin
        create(user_id: user.id, certificate_type: certificate_type, title: Certification.type_to_title(certificate_type),
               cuid: SecureRandom.base64(10).gsub('/', '_').gsub(/=+$/, ''))
      rescue StandardError
        invalid_discord_ids << row['discord_id']
      end
    end
    invalid_discord_ids
  end

  def self.get_type_from_course_type(course_type)
    course_type_to_type = { 'dsa': 'course_dsa', 'frontend': 'course_frontend', 'backend': 'course_backend' }
    course_type_to_type.fetch(course_type.to_sym, nil)
  end
end
