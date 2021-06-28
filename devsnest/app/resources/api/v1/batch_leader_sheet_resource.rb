# frozen_string_literal: true

module Api
  module V1
    class BatchLeaderSheetResource < JSONAPI::Resource
      attributes :user_id, :group_id, :tha_by_owner, :scrum_sheet_filled, :meet_with_industry_mentor, :owner_active, :co_owner_active,
                  :remarks, :topics_to_cover, :rating, :creation_date, :active_members, :par_active_members, :inactive_members,
                  :extra_activity, :doubt_session_taker
    end
  end
end
