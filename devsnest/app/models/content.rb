# frozen_string_literal: true

# == Schema Information
#
# Table name: contents
#
#  id              :bigint           not null, primary key
#  data_type       :integer
#  difficulty      :integer
#  extra_link1     :string(255)
#  extra_link2     :string(255)
#  link            :string(255)
#  name            :string(255)
#  priority        :integer
#  question_type   :integer
#  reference_data  :json
#  score           :integer
#  video_questions :json
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  parent_id       :string(255)
#  unique_id       :string(255)
#
# Indexes
#
#  index_contents_on_parent_id  (parent_id)
#  index_contents_on_unique_id  (unique_id)
#
class Content < ApplicationRecord
  enum data_type: %i[question video article topic subtopic]
  enum difficulty: %i[easy medium hard]
  enum question_type: %i[class assignment]
  has_many :submission

  def self.split_by_difficulty
    Content.where(data_type: 'question').group(:difficulty).count
  end
end
