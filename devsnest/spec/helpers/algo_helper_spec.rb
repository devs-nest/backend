# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AlgoHelper do
  describe 'status int' do
    it 'returns int' do
      helper.order_status('Pending').should eq(-1)
    end
  end

  describe 'passed tc' do
    let(:user) { create(:user) }
    let(:question) { create(:challenge, user_id: user.id, name: 'two sum') }
    let(:run_submission) { create(:run_submission, user_id: user.id, challenge_id: question.id, passed_test_cases: 0, test_cases: { "token": { status_id: 3 } }) }
    it 'returns max score' do
      helper.passed_test_cases_count(run_submission).should eq(1)
    end
  end

  describe 'tc skel' do
    let!(:data) { { 'status' => { 'id' => 3, 'description' => 'Accepted' } } }
    it 'returns max score' do
      helper.prepare_test_case_result(data).should be_kind_of(Hash)
    end
  end
end
