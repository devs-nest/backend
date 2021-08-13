# frozen_string_literal: true

module Api
  module V1
    # Resource for Hackathon
    class HackathonResource < JSONAPI::Resource
      attributes :title, :tagline, :reference, :description, :image, :leaderboard, :participation, :judgement,
                 :milestones, :prizes, :starting_date, :ending_date
    end
  end
end
