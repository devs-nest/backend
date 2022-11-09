# frozen_string_literal: true

# == Schema Information
#
# Table name: article_submissions
#
#  id              :bigint           not null, primary key
#  submission_link :string(255)
#  article_id      :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_article_submissions_on_article_id              (article_id)
#  index_article_submissions_on_article_id_and_user_id  (article_id,user_id) UNIQUE
#  index_article_submissions_on_user_id                 (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (article_id => articles.id)
#  fk_rails_...  (user_id => users.id)
#
class ArticleSubmission < ApplicationRecord
  belongs_to :article
  belongs_to :user
end
