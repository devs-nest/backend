# frozen_string_literal: true

class HealthCheckController < ApplicationController
  def index
    return render_success if Rails.env.test?

    sidekiq_procs = Sidekiq::ProcessSet.new
    render_success if sidekiq_procs.empty?
  end
end
