# frozen_string_literal: true

# == Schema Information
#
# Table name: frontend_submissions
#
#  id              :bigint           not null, primary key
#  submission_link :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  content_id      :integer
#  user_id         :integer
#
class FrontendSubmission < ApplicationRecord
end
