# frozen_string_literal: true

# == Schema Information
#
# Table name: manual_login_changelogs
#
#  id           :bigint           not null, primary key
#  is_fulfilled :boolean          default(FALSE)
#  query_type   :integer
#  uid          :text(65535)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#
# Indexes
#
#  index_manual_login_changelogs_on_user_id  (user_id)
#
class ManualLoginChangelog < ApplicationRecord
  belongs_to :user
  enum query_type: %i[verification password_reset]

  def within_a_day?
    created_at + 24.hours > Time.now
  end
end
