# frozen_string_literal: true

module Api
  module V1
    class GroupcallsController < ApplicationController
      include JSONAPI::ActsAsResourceController

      def index
        groups = Groupcall.fetch_groups
        render json: groups
      end

      def create
        discord_id = params['data']['attributes']['discord_id']
        user = User.find_by(discord_id: discord_id)
        return render_error('User not found') if user.nil?

        meeting = Groupcall.add_meeting(user.id, params['data']['attributes']['choice'])
        render_success(meeting.as_json.merge("type": 'groupcalls'))
      end
    end
  end
end
