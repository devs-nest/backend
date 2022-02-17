# frozen_string_literal: true

require 'rails_helper'
RSpec.describe AwsSqsWorker, type: :worker do
  it 'enqueues a aws sqs worker' do
    AwsSqsWorker.new.perform('test', 'test')
  end
end
