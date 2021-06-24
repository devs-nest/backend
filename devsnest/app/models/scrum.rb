# frozen_string_literal: true

class Scrum < ApplicationRecord
    validates :user_id, uniqueness: { scope: :date}

    before_create do
        self.date = Date.current
    end
end
