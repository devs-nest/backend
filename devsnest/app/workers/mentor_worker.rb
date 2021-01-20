# frozen_string_literal: true

class MentorWorker
  include Sidekiq::Worker
  def perform
    # User.assign_mentor_all
  end
end
