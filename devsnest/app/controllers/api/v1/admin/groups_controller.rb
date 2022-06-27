# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Group Controller for Admin
      class GroupsController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth

        def context
          {
            user: @current_user
          }
        end

        def merge_two_groups
          params = request.params[:data][:attributes]
          return render_error({ message: 'Group with this Name Already Exists' }) if Group.find_by(name: params[:new_group_name])

          if Group.merge_two_groups(params[:group_1_id], params[:group_2_id], params[:preserved_group_id],
                                    { name: params[:new_group_name], owner_id: params[:owner_id], co_owner_id: params[:co_owner_id] })
            render_success({ message: 'Group Merged Succesfully!' })
          else
            render_error({ message: 'Error Occured while Merging, Please Verify all the Parameters!' })
          end
        end

        def fetch_group_details
          final_details = []
          Group.v2.all.each do |g|
            user = User.find_by(id: g.batch_leader_id) if g.batch_leader_id.present?
            final_details << [g.server&.name, g.id, g.name, user.present? ? user.name : 'NA']
          end
          render_success({ data: final_details })
        end

        def assign_batch_leader
          user = User.find_by(id: params.dig(:data, :attributes, 'user_id'))
          return render_error({ message: 'User Not Found' }) unless user.present?

          Group.where(batch_leader_id: user.id).each do |g|
            RoleModifierWorker.perform_async('delete_role', user.discord_id, g.name, g.sever&.guild_id)
          end
          assign_role_to_batchleader(user, Group.v2.where(id: params.dig(:data, :attributes, 'group_ids')))

          render_success({ message: 'Batch Leader Assigned Successfully!' })
        end
      end
    end
  end
end
