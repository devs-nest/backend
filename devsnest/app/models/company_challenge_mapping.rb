# frozen_string_literal: true

# == Schema Information
#
# Table name: company_challenge_mappings
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  challenge_id :integer
#  company_id   :integer
#
# Indexes
#
#  index_company_challenge_mappings_on_challenge_id_and_company_id  (challenge_id,company_id) UNIQUE
#
class CompanyChallengeMapping < ApplicationRecord
  belongs_to :challenge
  belongs_to :company
  validates_uniqueness_of :company_id, scope: :challenge_id
  after_commit :cache_expire

  def cache_expire
    company.touch
  end
end
