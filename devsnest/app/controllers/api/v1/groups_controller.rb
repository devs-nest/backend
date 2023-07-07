# frozen_string_literal: true

module Api
  module V1
    class GroupsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      include UtilConcern
      before_action :simple_auth
      before_action :user_auth, only: %i[create show join leave update]
      before_action :admin_auth, only: %i[promote]
      before_action :check_v2_eligible, only: %i[create join update]
      before_action :check_group_admin_auth, only: %i[update]
      before_action :change_discord_group_name, only: %i[update]
      before_action :bot_auth, only: %i[delete_group update_group_name update_batch_leader server_details team_details]
      before_action :deslug, only: %i[show]
      # before_action :check_authorization, only: %i[show]
      before_action :create_validations, only: %i[create]
      after_action :assign_leader, only: %i[create]
      before_action :description_emoji_parse, only: %i[create update]

      before_action :course_validations, only: %i[index show]

      def context
        {
          user: @current_user, is_create: request.post?,
          slug: params[:id], fetch_v1: params[:v1].present?,
          fetch_all: params[:all_groups].present?,
          group_id: params[:group_id], is_get: request.get?
        }
      end

      def check_v2_eligible
        return false if @current_user.nil?

        return true if @current_user.is_admin?

        render_unauthorized unless @current_user.discord_active
      end

      # def check_authorization
      #   group = Group.find_by(id: params[:id])
      #   return render_not_found unless group.present?

      #   return render_forbidden if @current_user.nil?

      #   return render_forbidden unless group.check_auth(@current_user)
      # end

      def check_group_admin_auth
        group = Group.find_by(id: params[:id])
        group.group_admin_auth(@current_user)
      end

      def change_discord_group_name
        group = Group.find_by(id: params[:id])
        new_group_name = params.dig(:data, :attributes, 'name')
        return if group.nil? || new_group_name.nil?

        GroupModifierWorker.perform_async('update', [group.name, new_group_name], group.bootcamp_type, group.server.guild_id) if group.name != new_group_name
      end

      def deslug
        slug_name = params[:id]
        group = Group.find_by(slug: slug_name)
        return render_not_found unless group.present?

        params[:id] = group.id
      end

      def delete_group
        group_name = params['data']['attributes']['group_name']
        group = Group.find_by(name: group_name)
        return render_error('Group not found') if group.nil?

        GroupModifierWorker.perform_async('destroy', [group_name], group.bootcamp_type, group&.server&.guild_id)
        group.destroy
      end

      def update_group_name
        old_group_name = params['data']['attributes']['old_group_name']
        new_group_name = params['data']['attributes']['new_group_name']
        group = Group.find_by(name: old_group_name)
        return render_error('Group not found') if group.nil?

        group.update(name: new_group_name)
        render_success(group.as_json.merge({ 'type': 'group' }))
      end

      def update_batch_leader
        group = Group.find_by(name: params['data']['attributes']['group_name'])
        batch_leader = User.find_by(discord_id: params['data']['attributes']['discord_id'])
        return render_error('Group not found') if group.nil?

        group.update(batch_leader_id: batch_leader.nil? ? nil : batch_leader.id)
      end

      def join
        user = @current_user
        return render_error(message: 'User not found') if user.nil?

        user.update!(accepted_in_course: true)
        # can user join a v2 group?
        group = if params[:data][:attributes][:group_id].present?
                  Group.find(params[:data][:attributes][:group_id])
                else
                  Group.all.v2.visible.under_limited_members.sample
                end

        return render_error(message: 'Group not found') if group.nil?

        GroupMember.where(user_id: user.id).includes(:group).each do |group_member|
          return render_error(message: "User already present in the #{group.bootcamp_type} group") if group_member.group.bootcamp_type == group.bootcamp_type
        end

        ActiveRecord::Base.transaction do
          group.group_members.create!(user_id: user.id)
          user.update(group_assigned: true)
          raise StandardError, 'Group is already full!' if group.group_members.count > 16

          # group.update!(members_count: group.members_count + 1) #TODO
        end
        RoleModifierWorker.perform_async('add_role', user&.discord_id, group&.name, group&.server&.guild_id)
        send_group_change_message(user, group)
        api_render(200, { id: group.id, type: 'groups', slug: group.slug, message: 'Group joined' })
      rescue ActiveRecord::RecordInvalid => e
        render_error(message: e)
      rescue ActiveRecord::RecordNotUnique
        user.update(group_assigned: true)
        render_error(message: 'User already present in the given group')
      rescue StandardError => e
        render_error(message: e)
      end

      def leave
        user = @current_user
        return render_error(message: 'User not found') if user.nil?

        group = Group.find(params[:id])
        return render_error(message: 'Group not found') if group.nil?

        group_name = group.name
        guild_id = Server.find_by(id: group.server_id)&.guild_id

        ActiveRecord::Base.transaction do
          group.group_members.find_by!(user_id: user.id).destroy
          # group.update!(members_count: group.members_count - 1) #TODO
          group.reassign_leader(user.id)
          user.update(group_assigned: false)
        end
        # we need to pass guild id here because we do not have the group now
        RoleModifierWorker.perform_async('delete_role', user.discord_id, group.name, guild_id)
        GroupModifierWorker.perform_async('destroy', [group_name], group.bootcamp_type, guild_id) if Group.find_by(id: params[:id]).blank?

        render_success(message: 'Group left')
      rescue ActiveRecord::RecordNotFound
        render_error(message: 'User not in this group')
      rescue StandardError => e
        render_error(message: "Something went wrong! : #{e}")
      end

      def create_validations
        return render_error(message: 'User not connected to discord') unless @current_user.discord_active

        bootcamp_type = params.dig(:data, :attributes, :bootcamp_type) || 'dsa'
        GroupMember.where(user_id: @current_user.id).includes(:group).each do |group_member|
          return render_error(message: "User in the #{bootcamp_type} group can't create another #{bootcamp_type} group") if group_member.group.bootcamp_type == bootcamp_type
        end

        render_error(message: 'Group with this name already exists') if Group.find_by(name: params[:data][:attributes][:name]).present?

        params[:data][:attributes][:owner_id] = @current_user.id
      end

      def promote
        user_to_be_promoted = params[:data][:attributes][:user_id].to_i
        group_id = params[:data][:attributes][:group_id].to_i
        promote_to = params[:data][:attributes][:promotion_type].to_s
        group = Group.find(group_id)

        membership_entity = GroupMember.find_by(user_id: user_to_be_promoted, group_id: group_id)

        return render_error(message: 'User does not belong to this group') if membership_entity.nil?

        case promote_to
        when 'owner'
          return render_error(message: "This user is already #{promote_to} of this group") if group.owner_id == user_to_be_promoted

          group.promote_to_tl(user_to_be_promoted)
        when 'co_owner'
          return render_error(message: "This user is already #{promote_to} of this group") if group.co_owner_id == user_to_be_promoted

          group.promote_to_vtl(user_to_be_promoted)
        end

        render_success(message: 'User has been promoted')
      end

      def assign_leader
        if response.created?
          parsed_response = JSON.parse(response.body)
          group = Group.find(parsed_response['data']['id'].to_i)
          # group.update!(members_count: group.members_count + 1) #TODO
          group.group_members.create!(user_id: @current_user.id)
          GroupModifierWorker.perform_async('create', [group.name], group.bootcamp_type, group.server&.guild_id)
          RoleModifierWorker.perform_async('add_role', @current_user.discord_id, group.name, group.server&.guild_id)
          send_group_change_message(@current_user, group)
          ping_discord(group, 'Instructions')
          ping_discord(group, 'Commands')
        end
      end

      def server_details
        server = Server.find_by(guild_id: params[:data][:attributes][:server_id])
        return render_error(message: 'Server not found') if server.nil?

        group_data = Group.where(server_id: server.id).pluck(:name, :bootcamp_type).map do |name, bootcamp_type|
          sanitized_name = name.gsub(/[^a-zA-Z0-9 \n]/, '_').gsub(/ +/, ' ')
          channel_name = sanitized_name.split(' ').map(&:downcase).join('-') + "-channel"
          { name: name, bootcamp_type: bootcamp_type, channel_name: channel_name }
        end

        render_success({ groups: group_data })
      end

      def team_details
        group = Group.find_by(name:  params.dig(:data, :attributes, 'group_name'))
        return render_error(message: 'Group not found') if group.nil?

        team_leader = group&.owner_id.present? ? User.find_by(id: group&.owner_id) : nil
        vice_team_leader = group&.co_owner_id.present? ? User.find_by(id: group.co_owner_id) : nil
        batch_leader = group&.batch_leader_id.present? ? User.find_by(id: group.batch_leader_id) : nil

        member_list = group.group_members.where.not(user_id: [group&.owner_id, group&.co_owner_id]).pluck(:user_id)
        group_members = User.where(id: member_list).pluck(:name, :discord_id)
        data = { team_leader: team_leader.present? ? [team_leader&.name, team_leader&.discord_id] : nil,
                 vice_team_leader: vice_team_leader.present? ? [vice_team_leader&.name, vice_team_leader&.discord_id] : nil,
                 batch_leader: batch_leader.present? ? [batch_leader&.name, batch_leader&.discord_id] : nil,
                 members: group_members }
        render_success(data)
      end

      def weekly_group_data
        group = Group.find_by(name: params.dig(:data, :attributes, 'group_name'))
        return render_error(message: 'Group not found') if group.nil?

        data = group.weekly_data
        render_success(result: data.as_json)
      end

      def description_emoji_parse
        params[:data][:attributes][:description] = params[:data][:attributes][:description].dup.force_encoding('ISO-8859-1').encode('UTF-8') if params[:data][:attributes][:description].present?
      end

      private

      def course_validations
        return render_unauthorized unless @current_user.discord_active
      end
    end
  end
end
