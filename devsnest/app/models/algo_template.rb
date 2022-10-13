# frozen_string_literal: true

# == Schema Information
#
# Table name: algo_templates
#
#  id           :bigint           not null, primary key
#  body         :text(65535)
#  head         :text(65535)
#  tail         :text(65535)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  challenge_id :integer
#  language_id  :integer
#
# Indexes
#
#  index_algo_templates_on_challenge_id_and_language_id  (challenge_id,language_id) UNIQUE
#
class AlgoTemplate < ApplicationRecord
  enum language: %i[python python3 java cpp c javascript typescript]
  belongs_to :challenge
end
