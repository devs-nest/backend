# == Schema Information
#
# Table name: projects
#
#  id             :bigint           not null, primary key
#  banner         :string(255)
#  challenge_type :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  challenge_id   :integer
#
class Project < ApplicationRecord
  belongs_to :challenge, polymorphic: true
end
