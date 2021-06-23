# frozen_string_literal: true

class Scrum < ApplicationRecord
    validates :user_id, uniqueness: { scope: :date}
end
