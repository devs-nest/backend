# frozen_string_literal: true

# Weekly Todo Resourses
class WeeklyTodo < ApplicationRecord
  belongs_to :group, foreign_key: 'group_id'
  validates_uniqueness_of :group_id, scope: :creation_week
  before_create do
    self.creation_week = Date.current.at_beginning_of_week
  end
end
