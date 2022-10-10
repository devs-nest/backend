# frozen_string_literal: true

# worker that syncs groups with discord
class GroupSyncWorker
  include Sidekiq::Worker
  include UtilConcern
  sidekiq_options retry: 5
  def perform(group_name = '', server_id = '')
    return if server_id.empty?

    if group_name.empty?
      Group.where(server_id: server_id).each(&:invite_inactive_members)
    else
      group = Group.find_by(name: group_name)
      group.invite_inactive_members if group.present?
    end
  end
end
