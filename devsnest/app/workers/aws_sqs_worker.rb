# frozen_string_literal: true

# send a message to a queue using sqs
class AwsSqsWorker
  include Sidekiq::Worker

  def perform(message_type, message_body)
    $sqs.send_message(
      queue_url: ENV['SQS_URL'],
      message_body: {
        "type": message_type,
        "payload": message_body
      }.to_json,
      message_group_id: 'devsnest'
    )
  end
end
