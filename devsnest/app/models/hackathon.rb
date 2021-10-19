# frozen_string_literal: true

# Hackathon Model
class Hackathon < ApplicationRecord
  # after_create :create_certifications

  # def create_certifications
  #   leaderboard['data'].each do |team|
  #     team.members.each do |member|
  #       id = member[0]
  #       name = member[1]
  #       Certification.create(user_id: id, user_name: name, hackathon_name: title, rank: team.rank, team_name: team.team_name, issuing_date: Date.today)
  #     end
  #   end
  # end
end
