# frozen_string_literal: true

module Api
  module V1
    class GroupResource < JSONAPI::Resource
      attributes :name, :owner_id, :members_count, :student_mentor_id
      has_many :group_members
    end
  end
end
