# frozen_string_literal: true

# == Schema Information
#
# Table name: colleges
#
#  id   :bigint           not null, primary key
#  name :string(255)
#
class College < ApplicationRecord
  def self.create_college(college_name)
    College.create(name: college_name)
  end
end
