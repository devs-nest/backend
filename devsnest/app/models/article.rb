# frozen_string_literal: true

# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  author     :string(255)
#  banner     :string(255)
#  category   :string(255)
#  content    :text(65535)
#  slug       :string(255)
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_articles_on_slug  (slug) UNIQUE
#
class Article < ApplicationRecord
  has_many :article_submissions
  before_save :generate_slug

  def generate_slug
    self.slug = self.title.parameterize
  end
end
