# frozen_string_literal: true

# == Schema Information
#
# Table name: companies
#
#  id         :bigint           not null, primary key
#  image_url  :string(255)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_companies_on_name  (name) UNIQUE
#
class Company < ApplicationRecord
  has_many :company_challenge_mappings
  has_many :challenges, through: :company_challenge_mappings
  validates_uniqueness_of :name, case_sensitive: true
end
