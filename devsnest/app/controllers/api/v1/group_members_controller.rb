# frozen_string_literal: true

module Api
  module V1
    class GroupMembersController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :simple_auth
      before_action :check_authorization, except: %i[update_user_group]
      before_action :bot_auth, only: %i[update_user_group]

      def context
        { user: @current_user }
      end

      def check_authorization
        group = Group.find_by(id: params[:group_id])
        return render_not_found unless group.present?

        return render_forbidden unless group.check_auth(@current_user)
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
