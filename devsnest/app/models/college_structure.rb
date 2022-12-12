# frozen_string_literal: true

# == Schema Information
#
# Table name: college_structures
#
#  id             :bigint           not null, primary key
#  batch          :string(255)
#  branch         :integer
#  course         :integer
#  name           :string(255)
#  section        :string(255)
#  specialization :integer
#  year           :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  college_id     :integer
#
class CollegeStructure < ApplicationRecord
  has_many :college_profiles
  belongs_to :college

  before_save :assign_name

  enum course: %i[btech bca bba bsc]
  enum branch: %i[cs me ece civil it]

  validates_uniqueness_of :course, scope: %i[batch year branch section]

  SCHEMA = {
    course: %w[
      btech
      bca
      bba
      bsc
    ],
    year: {
      btech: [
        1, 2, 3, 4
      ],
      bca: [
        1, 2, 3
      ],
      bba: [
        1, 2, 3
      ],
      bsc: [
        1, 2, 3
      ]
    },
    batch: {
      btech: %w[
        2018-2022
        2019-2023
        2020-2024
        2021-2025
        2022-2026
      ],
      bca: %w[
        2018-2021
        2019-2022
        2020-2023
        2021-2024
        2022-2025
      ],
      bba: %w[
        2018-2021
        2019-2022
        2020-2023
        2021-2024
        2022-2025
      ],
      bsc: %w[
        2018-2021
        2019-2022
        2020-2023
        2021-2024
        2022-2025
      ]
    },
    branch: {
      btech: %w[cs me ece civil],
      bca: %w[it]
    }
  }

  def assign_name
    arr = [batch, course, branch, specialization, section].compact
    self.name = arr.join('/')
  end

  def self.split_batch(batch)
    batch.split('-').map(&:to_i)
  end

  def self.calc_year(year, course)
    [SCHEMA[:year][course.to_sym].max, Date.today.year - year + Date.today.month >= 6 ? 1 : 0].max
  end
end
