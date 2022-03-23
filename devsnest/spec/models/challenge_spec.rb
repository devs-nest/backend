# frozen_string_literal: true

require 'rails_helper'
require 'algo_templates/python3'
require 'algo_templates/python2'
require 'algo_templates/javascript'
require 'algo_templates/java'
require 'algo_templates/cpp'
require 'sidekiq/testing'
require 'leaderboard'
require 'competition_ranking_leaderboard'
Sidekiq::Testing.fake?

RSpec.describe Challenge, type: :model do
  context 'algo template specs' do
    let!(:question) do
      create(:challenge, topic: 0, question_body: 'testbody xyz', user_id: user.id, name: 'two sum test', is_active: true, score: 100,
                         input_format: [{ "name": 'n', "variable": { "dtype": 'int', "dependent": [], "datastructure": 'primitive' } }, { "name": 'arr', "variable": { "dtype": 'int', "dependent": ['n'], "datastructure": 'array' } }],
                         output_format: [{ "name": 'out', "variable": { "dtype": 'int', "datastructure": 'array' } }])
    end

    context 'python3 template' do
      let(:user) { create(:user) }
      let!(:python3) { create(:language, judge_zero_id: 71, name: 'python3') }

      it 'should create a template for python3' do
        algo_template = Templates::Python3.new(question.input_format, question.output_format)
        template = algo_template.build
        expect(template[:head]).to eq('')
      end
    end

    context 'python2 template' do
      let(:user) { create(:user) }
      let!(:python2) { create(:language, judge_zero_id: 72, name: 'python2') }

      it 'should create a template for python2' do
        algo_template = Templates::Python2.new(question.input_format, question.output_format)
        template = algo_template.build
        expect(template[:head]).to eq('')
      end
    end

    context 'java template' do
      let(:user) { create(:user) }
      let!(:java) { create(:language, judge_zero_id: 4, name: 'java', type_array: '_[]', type_matrix: '_[][]', type_string: 'String', type_primitive: '_') }

      it 'should create a template for Java' do
        algo_template = Templates::Java.new(question.input_format, question.output_format)
        template = algo_template.build
        expect(template[:head]).not_to be_empty
      end
    end

    context 'cpp template' do
      let(:user) { create(:user) }
      let!(:cpp) { create(:language, judge_zero_id: 5, name: 'cpp', type_array: 'vector<_>', type_matrix: 'vector>', type_string: '_', type_primitive: '_') }
      
      it 'should create a template for CPP' do
        algo_template = Templates::CPP.new(question.input_format, question.output_format)
        template = algo_template.build
        expect(template[:head]).not_to be_empty
      end
    end

    context 'check competetive leaderboard' do
      let!(:user) { create(:user) }
      let!(:user2) { create(:user) }
      let!(:user3) { create(:user) }
      let!(:spec_leaderboard) { Leaderboard.new('dn_leaderboard-test', Devsnest::Application::REDIS_OPTIONS, { redis_connection: Redis.new(url: 'redis://127.0.0.1:6379/0') }) }
      let!(:ch_leaderboard) { question.generate_leaderboard }
      let!(:u_s1) { create(:algo_submission, user_id: user.id, challenge_id: question.id, passed_test_cases: 7, total_test_cases: 10, is_best_submission: true, is_submitted: true) }
      let!(:u3_s1) { create(:algo_submission, user_id: user3.id, challenge_id: question.id, passed_test_cases: 7, total_test_cases: 10, is_best_submission: true, is_submitted: true) }
      let!(:u_s2) { create(:algo_submission, user_id: user.id, challenge_id: question.id, passed_test_cases: 10, total_test_cases: 10, is_best_submission: false, is_submitted: false) }
      let!(:u2_s1) { create(:algo_submission, user_id: user2.id, challenge_id: question.id, passed_test_cases: 1, total_test_cases: 10, is_best_submission: false, is_submitted: true) }
      let!(:u2_s2) { create(:algo_submission, user_id: user2.id, challenge_id: question.id, passed_test_cases: 5, total_test_cases: 10, is_best_submission: true, is_submitted: true) }
      before do
        question.regenerate_challenge_leaderboard
      end

      it 'should generate competetive leaderboard' do
        expect(ch_leaderboard.rank_for(user.username)).to eq(1)
        expect(ch_leaderboard.score_for(user.username)).to eq(70.0)
        expect(ch_leaderboard.rank_for(user3.username)).to eq(1)
        expect(ch_leaderboard.score_for(user3.username)).to eq(70.0)
        expect(ch_leaderboard.rank_for(user2.username)).to eq(3)
        expect(ch_leaderboard.score_for(user2.username)).to eq(50.0)
      end
    end

    context 'check competetive leaderboard' do
      let!(:user) { create(:user) }
      let!(:user2) { create(:user) }
      let!(:user3) { create(:user) }
      let!(:spec_leaderboard) { Leaderboard.new('dn_leaderboard-test', Devsnest::Application::REDIS_OPTIONS, { redis_connection: Redis.new(url: 'redis://127.0.0.1:6379/0') }) }
      let!(:ch_leaderboard) { question.generate_leaderboard }
      let!(:u_s1) { create(:algo_submission, user_id: user.id, challenge_id: question.id, passed_test_cases: 7, total_test_cases: 10, is_best_submission: true, is_submitted: true) }
      let!(:u3_s1) { create(:algo_submission, user_id: user3.id, challenge_id: question.id, passed_test_cases: 7, total_test_cases: 10, is_best_submission: true, is_submitted: true) }
      let!(:u_s2) { create(:algo_submission, user_id: user.id, challenge_id: question.id, passed_test_cases: 10, total_test_cases: 10, is_best_submission: false, is_submitted: false) }
      let!(:u2_s1) { create(:algo_submission, user_id: user2.id, challenge_id: question.id, passed_test_cases: 1, total_test_cases: 10, is_best_submission: false, is_submitted: true) }
      let!(:u2_s2) { create(:algo_submission, user_id: user2.id, challenge_id: question.id, passed_test_cases: 5, total_test_cases: 10, is_best_submission: true, is_submitted: true) }

      before do
        question.regenerate_challenge_leaderboard
        question.update!(score: 10)
      end

      it 'should generate competetive leaderboard' do
        expect(ch_leaderboard.rank_for(user.username)).to eq(1)
        expect(ch_leaderboard.score_for(user.username)).to eq(7.0)
        expect(ch_leaderboard.rank_for(user3.username)).to eq(1)
        expect(ch_leaderboard.score_for(user3.username)).to eq(7.0)
        expect(ch_leaderboard.rank_for(user2.username)).to eq(3)
        expect(ch_leaderboard.score_for(user2.username)).to eq(5.0)
      end
    end

    context 'will reevaluate score' do
      let!(:user) { create(:user) }
      let!(:user2) { create(:user) }
      let!(:user3) { create(:user) }
      let!(:spec_leaderboard) { Leaderboard.new('dn_leaderboard-test', Devsnest::Application::REDIS_OPTIONS, { redis_connection: Redis.new(url: 'redis://127.0.0.1:6379/0') }) }
      let!(:ch_leaderboard) { question.generate_leaderboard }
      let!(:u_s1) { create(:algo_submission, user_id: user.id, challenge_id: question.id, passed_test_cases: 7, total_test_cases: 10, is_best_submission: true, is_submitted: true) }
      let!(:u3_s1) { create(:algo_submission, user_id: user3.id, challenge_id: question.id, passed_test_cases: 7, total_test_cases: 10, is_best_submission: true, is_submitted: true) }
      let!(:u_s2) { create(:algo_submission, user_id: user.id, challenge_id: question.id, passed_test_cases: 10, total_test_cases: 10, is_best_submission: false, is_submitted: false) }
      let!(:u2_s1) { create(:algo_submission, user_id: user2.id, challenge_id: question.id, passed_test_cases: 1, total_test_cases: 10, is_best_submission: false, is_submitted: true) }
      let!(:u2_s2) { create(:algo_submission, user_id: user2.id, challenge_id: question.id, passed_test_cases: 5, total_test_cases: 10, is_best_submission: true, is_submitted: true) }

      before do
        question.regenerate_challenge_leaderboard
        question.update!(score: 10)
      end

      it 'should re eval' do
        UserScoreUpdate.perform_async([10, 100, question.id])
        expect {
          UserScoreUpdate.perform_async([10, 100, question.id])
        }.to change(UserScoreUpdate.jobs, :size).by(1)
      end
    end

    context 'will reevaluate score' do
      let!(:user) { create(:user) }
      let!(:user2) { create(:user) }
      let!(:user3) { create(:user) }
      let!(:spec_leaderboard) { Leaderboard.new('dn_leaderboard-test', Devsnest::Application::REDIS_OPTIONS, { redis_connection: Redis.new(url: 'redis://127.0.0.1:6379/0') }) }
      let!(:ch_leaderboard) { question.generate_leaderboard }
      let!(:u_s1) { create(:algo_submission, user_id: user.id, challenge_id: question.id, passed_test_cases: 7, total_test_cases: 10, is_best_submission: true, is_submitted: true) }
      let!(:u3_s1) { create(:algo_submission, user_id: user3.id, challenge_id: question.id, passed_test_cases: 7, total_test_cases: 10, is_best_submission: true, is_submitted: true) }
      let!(:u_s2) { create(:algo_submission, user_id: user.id, challenge_id: question.id, passed_test_cases: 10, total_test_cases: 10, is_best_submission: false, is_submitted: false) }
      let!(:u2_s1) { create(:algo_submission, user_id: user2.id, challenge_id: question.id, passed_test_cases: 1, total_test_cases: 10, is_best_submission: false, is_submitted: true) }
      let!(:u2_s2) { create(:algo_submission, user_id: user2.id, challenge_id: question.id, passed_test_cases: 5, total_test_cases: 10, is_best_submission: true, is_submitted: true) }

      before do
        question.regenerate_challenge_leaderboard
        question.update!(score: 10)
      end

      it 'should re eval' do
        UserScoreUpdate.perform_async([10, 100, question.id])
        expect {
          UserScoreUpdate.perform_async([10, 100, question.id])
        }.to change(UserScoreUpdate.jobs, :size).by(1)
      end
    end
  end
end
