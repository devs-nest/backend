# frozen_string_literal: true

class FrontendChallengeScore < ApplicationRecord
  belongs_to :user
  belongs_to :frontend_challenge
end
