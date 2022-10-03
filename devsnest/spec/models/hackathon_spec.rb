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
require 'rails_helper'

RSpec.describe Hackathon, type: :model do
end
