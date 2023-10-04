# frozen_string_literal: true

class HealthCheckController < ApplicationController
  def index
    sidekiq_procs = Sidekiq::ProcessSet.new
    render_success if sidekiq_procs.size > 0
  end

  def sidekiq_check
    render_success if Sidekiq::ProcessSet.new.size.positive?
  end
end
