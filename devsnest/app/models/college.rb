# frozen_string_literal: true

# == Schema Information
#
# Table name: colleges
#
#  id   :bigint           not null, primary key
#  name :string(255)
#
class College < ApplicationRecord
  has_many :college_profiles
  has_many :college_invites

  def self.create_college(college_name)
    College.create(name: college_name)
  end

  def self.domains_matched?(eamil1, email2)
    email1.split("@")[-1] == email2.split("@")[-1]
  end
end
