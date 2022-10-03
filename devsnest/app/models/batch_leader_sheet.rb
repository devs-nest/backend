# frozen_string_literal: true

# == Schema Information
#
# Table name: batch_leader_sheets
#
#  id                  :bigint           not null, primary key
#  Coordination        :integer
#  active_members      :text(65535)
#  co_owner_active     :integer
#  creation_week       :date
#  doubt_session_taker :text(65535)
#  inactive_members    :text(65535)
#  owner_active        :integer
#  par_active_members  :text(65535)
#  rating              :integer
#  remarks             :text(65535)
#  scrum_filled        :integer
#  tl_tha              :string(255)
#  video_scrum         :boolean
#  vtl_tha             :string(255)
#  group_id            :integer
#  user_id             :integer
#
# Indexes
#
#  index_batch_leader_sheets_on_group_id_and_creation_week  (group_id,creation_week) UNIQUE
#
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
