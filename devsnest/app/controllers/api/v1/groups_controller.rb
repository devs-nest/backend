# frozen_string_literal: true

module Api
  module V1
    class GroupsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :simple_auth
      before_action :bot_auth, only: %i[delete_group update_group_name]
      before_action :deslug, only: %i[show]
      before_action :check_authorization, only: %i[show]

      def context
        { user: @current_user }
      end

      def check_authorization
        group = Group.find_by(id: params[:id])
        return render_not_found unless group.present?

        return render_forbidden unless group.check_auth(@current_user)
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
    end
  end
end
