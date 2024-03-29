# frozen_string_literal: true

# == Schema Information
#
# Table name: bootcamp_progresses
#
#  id                   :bigint           not null, primary key
#  completed            :boolean          default(FALSE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  course_curriculum_id :integer
#  course_id            :integer
#  user_id              :integer
#
# Indexes
#
#  index_bootcamp_progresses_on_user_id  (user_id)
#
class BootcampProgress < ApplicationRecord
  belongs_to :user
  belongs_to :course, optional: true
  belongs_to :course_module, optional: true
  belongs_to :course_curriculum

  after_create :send_welcome_mail
  after_update :send_completion_mail, if: ->(obj) { obj.previous_changes.key?('completed') && obj.completed == true }

  def send_welcome_mail
    user = User.get_by_cache(user_id)
    template_id = EmailTemplate.find_by(name: 'bootcamp_welcome_mail_lm').try(:template_id)
    return if user.blank? || template_id.blank?

    EmailSenderWorker.perform_async(user.email, {
                                      'username': user.name.blank? ? user.username : user.name.titleize,
                                      'course_name': course_curriculum.course_type.upcase
                                    },
                                    template_id)
  end

  def send_completion_mail
    user = User.get_by_cache(user_id)
    course_curriculum = CourseCurriculum.get_by_cache(course_curriculum_id)
    template_id = EmailTemplate.find_by(name: 'bootcamp_completion_mail_lm').try(:template_id)
    return if user.blank? || template_id.blank?

    # Not generating certificates automatically for JTD bootcamp students
    return if course_curriculum&.course_module&.name&.split(' ')&.first == 'JTD'

    type = Certification.get_type_from_course_type(course_curriculum.course_type)
    certificate = Certification.find_by(user_id: user.id, certificate_type: type)
    if certificate.blank?
      certificate = Certification.create(user_id: user.id, certificate_type: type, title: Certification.type_to_title(type), cuid: SecureRandom.base64(10).gsub('/', '_').gsub(/=+$/, ''))
    end
    EmailSenderWorker.perform_async(user.email, {
                                      'username': user.name.blank? ? user.username : user.name.titleize,
                                      'course_name': course_curriculum.course_type.upcase,
                                      'certificate_link': "https://devsnest.in/certificate/#{certificate.cuid}"
                                    },
                                    template_id)
  end
end
