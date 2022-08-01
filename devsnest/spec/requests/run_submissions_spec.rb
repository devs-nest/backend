# frozen_string_literal: true

require 'rails_helper'
include AlgoHelper

RSpec.describe 'Run submissions', type: :request do
  let(:user) { create(:user) }
  let(:question) { create(:challenge, user_id: user.id, name: 'two sum') }
  let!(:run_submission) { create(:run_submission, user_id: user.id, challenge_id: question.id, test_cases: { "8531f293-1585-4d36-a34c-73726792e6c9": {} }) }
  let!(:test) { create(:testcase, challenge_id: question.id, input_path: 'example/ipath', output_path: 'example/opath') }
  before :each do
    sign_in(user)
  end

  let(:params) do
    {
      "data": {
        "attributes": {
          "challenge_id": question.id,
          "language": 'python3',
          "source_code": 'code',
          "user_id": user.id
        },
        "type": 'frontend_submissions'
      }
    }
  end

  let(:jz_callback_payload) do
    {
      "stdout": "hello, Judge0\n",
      "time": '0.001',
      "memory": 376,
      "stderr": nil,
      "token": '8531f293-1585-4d36-a34c-73726792e6c9',
      "compile_output": nil,
      "message": nil,
      "status": {
        "id": 3,
        "description": 'Accepted'
      }
    }
  end

  let(:payload) do
    {
      "source_code": 'code',
      "language_id": 71,
      "number_of_runs": '1',
      "stdin": 'test',
      "expected_output": 'test',
      "cpu_time_limit": '2',
      "cpu_extra_time": '0.5',
      "wall_time_limit": '5',
      "memory_limit": '512000',
      "stack_limit": '64000',
      "max_processes_and_or_threads": '10',
      "enable_per_process_and_thread_time_limit": false,
      "enable_per_process_and_thread_memory_limit": false,
      "max_file_size": '1024',
      "callback_url": 'test/callback'
    }
  end

  let(:token_set) do
    "[\r\n  {\r\n    \"token\": \"db54881d-bcf5-4c7b-a2e3-d33fe7e25de7\"\r\n  },\r\n  {\r\n    \"token\":
    \"ecc52a9b-ea80-4a00-ad50-4ab6cc3bb2a1\"\r\n  },\r\n  {\r\n    \"token\": \"1b35ec3b-5776-48ef-b646-d5522bdeb2cc\"\r\n  }\r\n]"
  end

  context 'run code' do
    before do
      allow(AlgoSubmission).to receive(:post_to_judgez).and_return(token_set)
      allow(AlgoSubmission).to receive(:add_submission).and_return([payload, 'test', 'test'])
    end
    it 'should create submissions' do
      post '/api/v1/algo-submission?run_code=true', params: params
      expect(response).to have_http_status(201)
    end
  end

  context 'run sub callback' do
    let!(:judgeztoken1) { create(:judgeztoken, submission_id: run_submission.id, token: '8531f293-1585-4d36-a34c-73726792e6c9') }

    before do
      allow(AlgoSubmission).to receive(:post_to_judgez).and_return(token_set)
      allow(AlgoSubmission).to receive(:add_submission).and_return([payload, 'test', 'test'])
    end
    it 'should update submissions' do
      put "/api/v1/run-submission/callback?submission_id=#{run_submission.id}", params: jz_callback_payload
      expect(response).to have_http_status(204)
    end
  end
end
