# frozen_string_literal: true

# == Schema Information
#
# Table name: server_users
#
#  id         :bigint           not null, primary key
#  active     :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  server_id  :integer
#  user_id    :integer
#
# Indexes
#
#  index_server_users_on_user_id_and_server_id  (user_id,server_id)
#
class ServerUser < ApplicationRecord
end
