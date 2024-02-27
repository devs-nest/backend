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
            final_details << { server_name: g.server&.name, group_id: g.id, group_name: g.name, batch_leader_id: g.batch_leader_id, batch_leader_id_name: user.present? ? user.name : 'NA' }
          end
          render_success({ data: final_details })
        end

        def assign_batch_leader
          user = User.find_by(id: params.dig(:data, :attributes, 'user_id'))
          return render_error({ message: 'User Not Found' }) unless user.present?

          Group.where(batch_leader_id: user.id).each do |g|
            g.update(batch_leader_id: nil)
            RoleModifierWorker.perform_async('delete_role', user.discord_id, g.name, g.server&.guild_id)
          end
          assign_role_to_batchleader(user, Group.v2.where(id: params.dig(:data, :attributes, 'group_ids')))

          render_success({ message: 'Batch Leader Assigned Successfully!' })
        end

        def student_details
          type = params[:type]
          start_date = params[:start_date]
          end_date = params[:end_date]
          return render_error(message: "Params missing") unless [type, start_date, end_date].all?

          file_record = FileUploadRecord.create(status: 0, user: @current_user, file_type: type)
          FileUploadWorker.perform_async(type, [start_date, end_date], file_record.id)

          render_success({message: 'File request queued'})
        end

        def studend_reports
          render_success({ message: 'Reports Fetched', data: FileUploadRecord.where(user: @current_user) })
        end
        

        def add_user
          user = User.find_by(id: params[:user_id])
          return render_error(message: 'User Not Found') if user.nil?

          return render_error(message: 'Discord not connected.') if user.discord_active == false

          user.update!(accepted_in_course: true)
          group = Group.find_by(id: params[:id])
          return render_error(message: 'Group Not Found') if group.nil?

          GroupMember.where(user_id: user.id).includes(:group).each do |group_member|
            return render_error(message: "User already present in the #{group.bootcamp_type} group") if group_member.group.bootcamp_type == group.bootcamp_type
          end

          ActiveRecord::Base.transaction do
            group.group_members.create!(user_id: user.id)
            user.update(group_assigned: true)
            raise StandardError, 'Group is already full!' if group.group_members.count > 16
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
      end
    end
  end
end
