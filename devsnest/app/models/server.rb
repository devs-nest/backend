# frozen_string_literal: true

# == Schema Information
#
# Table name: servers
#
#  id         :bigint           not null, primary key
#  link       :string(255)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  guild_id   :string(255)
#
class Server < ApplicationRecord
  has_many :groups
end
