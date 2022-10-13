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
require 'rails_helper'

RSpec.describe ManualLoginChangelog, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
