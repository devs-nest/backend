# == Schema Information
#
# Table name: college_enquiries
#
#  id            :bigint           not null, primary key
#  enquiry_count :integer          default(0)
#  phone_number  :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_college_enquiries_on_phone_number  (phone_number)
#
class CollegeEnquiry < ApplicationRecord
end
