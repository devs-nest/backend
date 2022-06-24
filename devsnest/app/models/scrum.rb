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
    else
      params = (params.dig 'data', 'attributes').except(:user_id, :group_id, :creation_date, :attendance)
    end
    update!(params)
  end
end
