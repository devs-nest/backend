# == Schema Information
#
# Table name: algo_submissions
#
#  id                 :bigint           not null, primary key
#  is_best_submission :boolean          default(FALSE)
#  is_submitted       :boolean
#  language           :string(255)
#  passed_test_cases  :integer          default(0)
#  source_code        :text(65535)
#  status             :string(255)
#  test_cases         :json
#  total_memory       :string(255)
#  total_runtime      :string(255)
#  total_test_cases   :integer          default(0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  challenge_id       :integer
#  user_id            :integer
#
# Indexes
#
#  index_algo_submissions_on_is_submitted_and_status   (is_submitted,status)
#  index_algo_submissions_on_user_id_and_challenge_id  (user_id,challenge_id)
#
require 'rails_helper'

RSpec.describe AlgoSubmission, type: :model do
  let(:user) { create(:user) }
  let(:challenge) { create(:challenge) }

  it 'Should call assign score to user function' do

  end
end
