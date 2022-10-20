# frozen_string_literal: true

# == Schema Information
#
# Table name: organizations
#
#  id          :bigint           not null, primary key
#  additional  :json
#  description :text(65535)
#  heading     :string(255)
#  logo        :string(255)
#  logo_banner :string(255)
#  name        :string(255)
#  slug        :string(255)
#  website     :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_organizations_on_slug  (slug) UNIQUE
#
class Organization < ApplicationRecord
  has_many :jobs
end
