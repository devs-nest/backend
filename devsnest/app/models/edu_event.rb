# frozen_string_literal: true

# == Schema Information
#
# Table name: edu_events
#
#  id            :bigint           not null, primary key
#  description   :text(65535)
#  ending_date   :date
#  organizer     :string(255)
#  starting_date :date
#  title         :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class EduEvent < ApplicationRecord
  has_many :event_registrations
  has_many :users, through: :event_registrations
end
