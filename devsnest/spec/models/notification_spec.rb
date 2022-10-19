# frozen_string_literal: true

# == Schema Information
#
# Table name: notifications
#
#  id              :bigint           not null, primary key
#  date_to_be_sent :date
#  is_sent         :boolean          default(FALSE)
#  message         :text(65535)
#  users           :json
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'rails_helper'

RSpec.describe Notification, type: :model do
end
