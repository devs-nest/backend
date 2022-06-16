# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Group Controller for Admin
      class GroupController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth

        def context
          {
            user: @current_user
          }
        end

        def merge_two_groups
          return render_error({ message: 'Group with this Name Already Exists' }) if Group.find_by(name: params[:new_group_name])

          if Group.merge_two_groups(params[:group_1_id], params[:group_2_id], params[:preserved_group_id], { name: params[:new_group_name], owner_id: params[:owner_id], co_owner_id: params[:co_owner_id] })
            render_success({ message: 'Group Merged Succesfully!' })
          else
            render_error({message: 'Error Occured while Merging, Please Verify all the Parameters!'})
          end
        end
      end
    end
  end
end
