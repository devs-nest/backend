# frozen_string_literal: true

class JwtBlacklist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist

  self.table_name = 'jwt_blacklists'
end
