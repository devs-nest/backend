# frozen_string_literal: true

# == Schema Information
#
# Table name: judgeztokens
#
#  id            :bigint           not null, primary key
#  token         :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  submission_id :integer
#
# Indexes
#
#  index_judgeztokens_on_token_and_submission_id  (token,submission_id)
#
class Judgeztoken < ApplicationRecord
end
