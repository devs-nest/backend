# frozen_string_literal: true

# == Schema Information
#
# Table name: testcases
#
#  id           :bigint           not null, primary key
#  input_path   :string(255)
#  is_sample    :boolean
#  output_path  :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  challenge_id :integer
#
# Indexes
#
#  index_testcases_on_challenge_id_and_is_sample  (challenge_id,is_sample)
#
require 'rails_helper'

RSpec.describe Testcase, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
