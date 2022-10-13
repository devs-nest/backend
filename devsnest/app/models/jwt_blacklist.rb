# frozen_string_literal: true

# == Schema Information
#
# Table name: jwt_blacklists
#
#  id  :bigint           not null, primary key
#  exp :datetime
#  jti :string(255)      not null
#
# Indexes
#
#  index_jwt_blacklists_on_jti  (jti)
#
class JwtBlacklist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist

  self.table_name = 'jwt_blacklists'
end
