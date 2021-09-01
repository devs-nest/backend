# frozen_string_literal: true

module Api
  module V1
    # Resource for Hackathon
    class HackathonResource < JSONAPI::Resource
      attributes :title, :tagline, :reference, :description, :image, :leaderboard, :participation, :judgement, :teams_participated,
                 :milestones, :prizes, :starting_date, :ending_date
      attributes :participants
    end
  end
end
