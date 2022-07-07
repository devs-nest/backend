require 'rails_helper'
RSpec.describe UserScoreUpdate, type: :worker do
  let!(:question) { create(:challenge, topic: 0, question_body: 'testbody xyz', user_id: user.id, name: 'two sum test', is_active: true, score: 100, input_format: [{ "name": 'n', "variable": { "dtype": 'int', "dependent": [], "datastructure": 'primitive' } }, { "name": 'arr', "variable": { "dtype": 'int', "dependent": ['n'], "datastructure": 'array' } }], output_format: [{ "name": 'out', "variable": { "dtype": 'int', "datastructure": 'array' } }]) }
  let!(:user) { create(:user, user_type: 1, discord_active: true) }
  let!(:u_s1) { create(:algo_submission, user_id: user.id, challenge_id: question.id, passed_test_cases: 7, total_test_cases: 10, is_best_submission: true, is_submitted: true) }
  let!(:u_s2) { create(:algo_submission, user_id: user.id, challenge_id: question.id, passed_test_cases: 10, total_test_cases: 10, is_best_submission: false, is_submitted: false) }
  
  it 'Should run worker' do
    UserScoreUpdate.new.perform(question.id)
  end
end
