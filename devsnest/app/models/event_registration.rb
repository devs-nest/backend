# frozen_string_literal: true

# == Schema Information
#
# Table name: event_registrations
#
#  id           :bigint           not null, primary key
#  user_data    :json
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  edu_event_id :integer
#  user_id      :integer
#
class EventRegistration < ApplicationRecord
  belongs_to :edu_event
  belongs_to :user
end
