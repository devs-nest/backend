# frozen_string_literal: true

# == Schema Information
#
# Table name: notification_bots
#
#  id             :bigint           not null, primary key
#  bot_token      :string(255)
#  bot_username   :string(255)
#  is_generic_bot :boolean          default(FALSE)
#  is_used        :boolean          default(FALSE)
#
require 'rails_helper'

RSpec.describe NotificationBot, type: :model do
end
