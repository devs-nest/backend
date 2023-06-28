# frozen_string_literal: true

module Api
  module V1
    class GroupMembersController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :simple_auth
      before_action :bot_auth, only: %i[update_user_group]
      before_action :admin_auth, only: %i[destroy]

      def context
        { user: @current_user, group_id: params[:group_id] }
      end

      def destroy
        group_member = GroupMember.find_by(id: params[:id])
        group_id = group_member.group_id
        group = group_member.group
        group_name = group.name

        guild_id = group.server&.guild_id
        user = User.find_by(id: group_member.user_id)

        ActiveRecord::Base.transaction do
          group_member.destroy
          # group.update!(members_count: group.members_count - 1) #TODO
          group.reassign_leader(user.id)
          user.update(group_assigned: false)
        end
        # we need to pass guild id here because we do not have the group now
        RoleModifierWorker.perform_async('delete_role', user.discord_id, group.name, guild_id)
        GroupModifierWorker.perform_async('destroy', [group_name], bootcamp_type, guild_id) if Group.find_by(id: group_id).blank?

        render_success(message: 'Group left')
      rescue StandardError => e
        render_error(message: "Something went wrong! : #{e}")
      end

      def update_user_group
        discord_id = params['data']['attributes']['discord_id']
        updated_group_name = params['data']['attributes']['updated_group_name']
        is_team_leader = params['data']['attributes']['is_team_leader']
        is_vice_team_leader = params['data']['attributes']['is_vice_team_leader']

        user = User.find_by(discord_id: discord_id)
        return render_error('User not found') if user.nil?

        current_group_member = GroupMember.find_by(user_id: user.id)

        if updated_group_name.present?
          # create group if not already exists
          new_group = Group.find_or_create_by(name: updated_group_name)

          # remove TL and VTL from old team
          Group.where(owner_id: user.id).update_all(owner_id: nil)
          Group.where(co_owner_id: user.id).update_all(co_owner_id: nil)

          if current_group_member.present?
            # user is member of a group just need to update it
            current_group_member.update(group_id: new_group.id)
          else
            # user was not part of any group need to create member
            GroupMember.create(user_id: user.id, group_id: new_group.id)
            user.update(group_assigned: true)
          end

          # update TL status
          new_group.update(owner_id: user.id) if is_team_leader
          # update VTL status
          new_group.update(co_owner_id: user.id) if is_vice_team_leader
        elsif current_group_member.present?
          # User has been removed from a team
          current_group_member.destroy
          user.update(group_assigned: false)
        end
        render_success({})
      end
    end
  end
end
