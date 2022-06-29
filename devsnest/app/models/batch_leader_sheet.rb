# frozen_string_literal: true

# Model
class BatchLeaderSheet < ApplicationRecord
  validates_uniqueness_of :group_id, scope: :creation_week
  serialize :doubt_session_taker, Array
  serialize :active_members, Array
  serialize :par_active_members, Array
  serialize :inactive_members, Array

  before_create do
    self.creation_week = Date.current.at_beginning_of_week
  end
end
