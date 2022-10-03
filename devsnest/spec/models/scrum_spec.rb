# frozen_string_literal: true

# == Schema Information
#
# Table name: scrums
#
#  id                        :bigint           not null, primary key
#  attendance                :boolean
#  backlog_reasons           :text(65535)
#  class_rating              :integer
#  creation_date             :date
#  last_tha_link             :string(255)
#  recent_assignments_solved :json
#  saw_last_lecture          :boolean
#  tha_progress              :string(255)
#  topics_to_cover           :string(255)
#  total_assignments_solved  :json
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  group_id                  :integer
#  user_id                   :integer
#
# Indexes
#
#  index_scrums_on_user_id_and_creation_date  (user_id,creation_date) UNIQUE
#
require 'rails_helper'

RSpec.describe Scrum, type: :model do
  context 'check creation' do
    let(:scrum) { create(:scrum) }
    let!(:course) { create(:course) }

    it 'check creation week' do
      expect(scrum.creation_date).to eq(Date.current)
    end
  end
end
