# frozen_string_literal: true

# send a message to a queue using sqs
class AwsSqsWorker
  include Sidekiq::Worker

  def perform(message_type, message_body, queue_url = ENV['SQS_URL'])
    $sqs&.send_message(
      queue_url: queue_url,
      message_body: {
        "type": message_type,
        "payload": message_body
      }.to_json,
      message_group_id: 'devsnest'
    )
  rescue Aws::SQS::Errors::NonExistentQueue
    puts 'Queue Does not exist'
  end
end
