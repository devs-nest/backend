# frozen_string_literal: true

# == Schema Information
#
# Table name: hackathons
#
#  id                 :bigint           not null, primary key
#  description        :text(65535)
#  ending_date        :date
#  image              :text(65535)
#  judgement          :text(65535)
#  leaderboard        :json
#  milestones         :text(65535)
#  participants       :json
#  participation      :text(65535)
#  prizes             :text(65535)
#  reference          :string(255)
#  starting_date      :date
#  tagline            :string(255)
#  teams_participated :integer
#  title              :string(255)
#
class Hackathon < ApplicationRecord
  # To DO
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
