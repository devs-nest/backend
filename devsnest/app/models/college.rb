# frozen_string_literal: true

# == Schema Information
#
# Table name: colleges
#
#  id          :bigint           not null, primary key
#  is_verified :boolean          default(FALSE)
#  name        :string(255)
#
class College < ApplicationRecord
  has_many :college_profiles
  has_many :college_invites
  has_many :college_structure

  def self.create_college(college_name)
    College.create(name: college_name)
  end

  def self.domains_matched?(email1, email2)
    email1.split("@")[-1] == email2.split("@")[-1]
  end
end
