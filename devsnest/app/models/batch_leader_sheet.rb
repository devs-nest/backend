# frozen_string_literal: true

class BatchLeaderSheet < ApplicationRecord
  serialize :doubt_session_taker, Array
  serialize :active_members, Array
  serialize :par_active_members, Array
  serialize :inactive_members, Array
  serialize :extra_activity, Array
end
