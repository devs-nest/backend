# frozen_string_literal: true

# CompanyChallengeMapping model
class CompanyChallengeMapping < ApplicationRecord
  belongs_to :challenge
  belongs_to :company
  validates_uniqueness_of :company_id, scope: :challenge_id
  after_commit :cache_expire

  def cache_expire
    company.touch
  end
end
