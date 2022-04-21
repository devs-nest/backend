# frozen_string_literal: true

module Api
  module V1
    class GroupsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :simple_auth
      before_action :user_auth, only: %i[create show join leave]
      before_action :check_v2_eligible, only: %i[create show join update]
      before_action :check_group_admin_auth, only: %i[update]
      before_action :bot_auth, only: %i[delete_group update_group_name update_batch_leader]
      before_action :deslug, only: %i[show]
      # before_action :check_authorization, only: %i[show]
      before_action :create_validations, only: %i[create]
      after_action :assign_leader, only: %i[create]

      def context
        { user: @current_user, is_create: request.post?, slug: params[:id], fetch_v1: params[:v1].present? }
      end

      def check_v2_eligible
        return false if @current_user.nil?
    
        @current_user.discord_active && @current_user.accepted_in_course
      end

      def check_authorization
        group = Group.find_by(id: params[:id])
        return render_not_found unless group.present?

        return render_forbidden if @current_user.nil?

        return render_forbidden unless group.check_auth(@current_user)
      end

      def check_group_admin_auth
        group = Group.find_by(id: params[:id])
        group.group_admin_auth(@current_user)
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

        # can user join a v2 group?
        if params[:data][:attributes][:group_id].present?
          group = Group.find(params[:data][:attributes][:group_id])
        else
          group = Group.all.v2.visible.under_12_members.sample
        end

        return render_error(message: 'Group not found') if group.nil?
    
        ActiveRecord::Base.transaction do
          group.group_members.create!(user_id: user.id)
          user.update(group_assigned: true)
          group.update!(members_count: group.members_count + 1)
        end
        api_render(200, { id: group.id, type: 'groups', slug: group.slug, message: "Group joined" })
      rescue ActiveRecord::RecordInvalid => e
        return render_error(message: e)
      rescue ActiveRecord::RecordNotUnique
        user.update(group_assigned: true)
        return render_error(message: 'User already in a group')
      rescue => e
        return render_error(message: "Something went wrong! : #{e}")
      end

      def leave
        user = @current_user
        return render_error(message: 'User not found') if user.nil?

        group = Group.find(params[:id])
        return render_error(message: 'Group not found') if group.nil?

        ActiveRecord::Base.transaction do
          group.group_members.find_by!(user_id: user.id).destroy
          group.update!(members_count: group.members_count - 1)
          group.reassign_leader(user.id)
          user.update(group_assigned: false)
        end

        render_success(message: 'Group left')
        rescue ActiveRecord::RecordNotFound
          return render_error(message: 'User not in this group')
        rescue => e
          return render_error(message: "Something went wrong! : #{e}")
      end

      def create_validations
        return render_error(message: 'User not connected to discord') unless @current_user.discord_active
        
        return render_error(message: "User in a group can't create another group") if @current_user.group_assigned || GroupMember.find_by_user_id(@current_user.id).present?
        
        return render_error(message: "Group with this name already exists") if Group.find_by_slug(params[:data][:attributes][:name]).present?
        params[:data][:attributes][:owner_id] = @current_user.id
      end

      def promote_to_vice_leader
        user_to_be_promoted = params[:data][:attributes][:user_id].to_i
        group_id = params[:data][:attributes][:group_id].to_i
        group = Group.find(group_id)

        membership_entity = GroupMember.find_by(user_id: user_to_be_promoted, group_id: group_id)

        return render_error(message: 'User does not belong to this group') if membership_entity.nil?
        
        return render_error(message: 'This user can not be promoted') if membership_entity.owner

        membership_entity.update(owner: true)
        group.update(co_owner_id: user_to_be_promoted)

        render_success(message: "User has been promoted")
      end

      def assign_leader
        if response.created?
          parsed_response = JSON.parse(response.body)
          group = Group.find(parsed_response['data']['id'].to_i)
          group.update!(members_count: group.members_count + 1)
          group.group_members.create!(user_id: @current_user.id, owner: true)
        end
      end
    end
  end
end
