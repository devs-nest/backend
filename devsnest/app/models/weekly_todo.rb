# frozen_string_literal: true

# Weekly Todo Resourses
class WeeklyTodo < ApplicationRecord
  belongs_to :group, foreign_key: 'group_id'
  validates :group_id, uniqueness: { scope: :creation_week }
  before_create do
    self.creation_week = Date.current.at_beginning_of_week
  end
end
