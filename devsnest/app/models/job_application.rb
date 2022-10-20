# frozen_string_literal: true

# == Schema Information
#
# Table name: job_applications
#
#  id                     :bigint           not null, primary key
#  email                  :string(255)
#  note_for_the_recruiter :string(255)
#  phone_number           :string(255)
#  status                 :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  job_id                 :integer
#  user_id                :integer
#
# Indexes
#
#  index_job_applications_on_user_id_and_job_id  (user_id,job_id) UNIQUE
#
class JobApplication < ApplicationRecord
  belongs_to :user
  belongs_to :job

  enum status: %i[applied interview offer rejected]
end
