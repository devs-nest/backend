# == Schema Information
#
# Table name: user_challenge_scores
#
#  id                 :bigint           not null, primary key
#  passed_test_cases  :integer
#  score              :integer          default(0)
#  total_test_cases   :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  algo_submission_id :integer
#  challenge_id       :integer
#  user_id            :integer
#
# Indexes
#
#  index_user_challenge_scores_on_user_id_and_challenge_id  (user_id,challenge_id) UNIQUE
#
require 'rails_helper'

RSpec.describe UserChallengeScore, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
