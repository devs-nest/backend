# frozen_string_literal: true

# == Schema Information
#
# Table name: internal_feedbacks
#
#  id                       :bigint           not null, primary key
#  BL_availability          :string(255)
#  BL_rating                :integer
#  TL_rating                :integer
#  VTL_rating               :string(255)
#  comments_on_BL           :text(65535)
#  feedback_type            :string(255)
#  group_activity_rating    :integer
#  group_morale             :text(65535)
#  is_resolved              :boolean          default(FALSE)
#  issue_details            :text(65535)
#  issue_scale              :integer          default(0)
#  obstacles_faced          :text(65535)
#  problems_faced           :string(255)      default("")
#  solution                 :text(65535)
#  tl_vtl_feedback          :text(65535)
#  user_name                :string(255)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  most_helpful_teammate_id :integer
#  user_id                  :bigint
#
# Indexes
#
#  index_internal_feedbacks_on_user_id  (user_id)
#
require 'rails_helper'

RSpec.describe InternalFeedback, type: :model do
end
