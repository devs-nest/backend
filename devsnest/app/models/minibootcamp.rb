# frozen_string_literal: true

# == Schema Information
#
# Table name: minibootcamps
#
#  id                    :bigint           not null, primary key
#  content_type          :integer
#  current_lesson_number :integer
#  image_url             :string(255)
#  markdown              :text(65535)
#  name                  :string(255)
#  show_ide              :boolean
#  video_link            :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  frontend_question_id  :integer
#  parent_id             :string(255)
#  unique_id             :string(255)      not null
#
# Indexes
#
#  index_minibootcamps_on_frontend_question_id  (frontend_question_id)
#
class Minibootcamp < ApplicationRecord
  enum content_type: %i[topic subtopic]
  belongs_to :frontend_question, optional: true
end
