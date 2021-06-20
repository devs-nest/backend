# frozen_string_literal: true

class GroupMember < ApplicationRecord
  audited
  belongs_to :group
end
