<<<<<<< HEAD
# frozen_string_literal: true

=======
>>>>>>> 7b58c63f5874672c86571b8c251c024a32c5c969
# == Schema Information
#
# Table name: projects
#
#  id             :bigint           not null, primary key
#  banner         :string(255)
#  challenge_type :string(255)
#  intro          :text(65535)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  challenge_id   :integer
#
class Project < ApplicationRecord
  belongs_to :challenge, polymorphic: true
  after_create :make_project_true
  after_destroy :make_project_false

  def challenge_data
    return { title: challenge.title, slug: challenge.slug } if challenge_type == 'Article'

    {
      name: challenge.name,
      difficulty: challenge.difficulty,
      slug: challenge.slug,
      score: challenge.score
    }
  end

  def make_project_true
    challenge.update!(is_project: true) if challenge_type != 'Article'
  end

  def make_project_false
    challenge.update!(is_project: false) if challenge_type != 'Article'
  end
end
