# == Schema Information
#
# Table name: otp_logs
#
#  id            :bigint           not null, primary key
#  phone_number  :string(255)
#  request_count :integer
#  timeout       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_otp_logs_on_phone_number  (phone_number)
#
class OtpLog < ApplicationRecord
end
