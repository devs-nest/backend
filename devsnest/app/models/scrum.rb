# frozen_string_literal: true

# scrum model
class Scrum < ApplicationRecord
  validates :user_id, uniqueness: { scope: :creation_date }

  before_create do
    self.creation_date = Date.current
  end

  def handle_manual_update(params, group, user)
    if group.admin_rights_auth(user)
      params = (params.dig 'data', 'attributes').except(:user_id, :group_id, :creation_date)
      params = params.permit(:attendance, :saw_last_lecture, :tha_progress, :topics_to_cover, :backlog_reasons, :class_rating)
    else
      params = (params.dig 'data', 'attributes').except(:user_id, :group_id, :creation_date, :attendance)
      params = params.permit(:saw_last_lecture, :tha_progress, :topics_to_cover, :backlog_reasons, :class_rating)
    end
    update!(params)
  end
end
