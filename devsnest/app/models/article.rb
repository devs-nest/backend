# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  author     :string(255)
#  content    :text(65535)
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Article < ApplicationRecord
  has_many :article_submissions
end
