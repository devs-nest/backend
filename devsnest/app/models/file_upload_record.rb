# frozen_string_literal: true
class FileUploadRecord < ApplicationRecord
  enum status: %i[processing done]
  enum file_type: %i[user_details scrum_details batch_leader_details]
  belongs_to :user
end
