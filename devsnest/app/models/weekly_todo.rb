# frozen_string_literal: true

# == Schema Information
#
# Table name: weekly_todos
#
#  id                    :bigint           not null, primary key
#  batch_leader_rating   :integer
#  comments              :text(65535)
#  creation_week         :date
#  extra_activity        :text(65535)
#  group_activity_rating :integer
#  moral_status          :integer
#  obstacles             :text(65535)
#  sheet_filled          :boolean
#  todo_list             :json
#  group_id              :integer
#
# Indexes
#
#  index_weekly_todos_on_group_id_and_creation_week  (group_id,creation_week) UNIQUE
#
class WeeklyTodo < ApplicationRecord
  belongs_to :group, foreign_key: 'group_id'
  validates_uniqueness_of :group_id, scope: :creation_week
  before_create do
    self.creation_week = Date.current.at_beginning_of_week
  end
end
