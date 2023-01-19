# frozen_string_literal: true

module Api
  module V1
    class CodingRoomsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth

      def index
        if active_user_group_check
          user_coding_rooms = CodingRoomUserMapping.where(user_id: @current_user.id, has_left: false).pluck(&:coding_room_id)
          coding_rooms = CodingRoom.where(id: user_coding_rooms, is_active: true)
        else
          coding_rooms = CodingRoom.active.public_rooms
        end

        return render_success(message: 'There are no active rooms') if coding_rooms.blank?

        render_success(coding_rooms: coding_rooms.as_json)
      end

      def create
        room_params = params.dig(:data, :attributes)
        topics = room_params[:topics]
        difficulty = room_params[:difficulty]
        number_of_questions = room_params[:number_of_questions]

        return render_error(message: 'You are a part of an active coding room') if active_user_group_check

        challenges = Challenge.active.where(topic: topics, difficulty: difficulty).sample(number_of_questions.to_i)
        room_details = CodingRoom.create!(name: room_params[:name], room_time: room_params[:room_time], is_private: room_params[:is_private], challenge_list: challenges.pluck(:id))
        CodingRoomUserMapping.create!(user_id: @current_user.id, coding_room_id: room_details.id)
        render_success(room_details: room_details, challenge_list: challenges)
      end

      def start_room
        coding_room_id = params[:coding_room_id]
        room = CodingRoom.find_by(id: coding_room_id)&.update(has_started: true)
        return render_error(message: 'No such Room exists') if room.nil?

        render_success(message: 'The room has started')
      end

      def join_room
        room_code = params[:unique_room_code]
        return render_error(message: 'You are a part of an active coding room') if active_user_group_check

        room = CodingRoom.find_by(unique_id: room_code, is_active: true)
        return render_error(message: "Room has ended or doesn't exist") if room.nil?

        CodingRoomUserMapping.create!(user_id: @current_user.id, coding_room_id: room.id)
        render_success(coding_room_id: room.id)
      end

      def show
        user_room = CodingRoomUserMapping.where(user_id: @current_user.id, has_left: false).last
        active_room = CodingRoom.find_by(id: user_room&.coding_room_id)
        return render_error(message: 'You are not a part of any room or the room has ended') if active_room.blank? || active_room.is_active == false

        challenge_list = active_room.challenge_list
        challenges = Challenge.where(id: challenge_list).order(:difficulty)
        remaining_time = (active_room.finish_at.to_i - Time.current.to_i).positive? ? (active_room.finish_at.to_i - Time.current.to_i).seconds : 0
        render_success(id: active_room.id, challenge: challenges, remaining_time: remaining_time)
      end

      def user_submissions
        coding_room = CodingRoom.find_by(id: params[:id])
        algo_submissions = AlgoSubmission.where(coding_room_id: coding_room.id, user_id: @current_user.id)
        render_success(submissions: algo_submissions)
      end

      def active_user_list
        room_id = params[:id]
        active_users = CodingRoomUserMapping.where(coding_room_id: room_id, has_left: false).includes(:user).map { |mapping| [mapping.user.name, mapping.user.username, mapping.user.image_url] }
        render_success(users: active_users.as_json)
      end

      def leave_room
        mappings = CodingRoomUserMapping.where(user_id: @current_user.id, coding_room_id: CodingRoom.active.pluck(:id))
        return render_error(message: 'You are not a part of any active room') unless mappings

        mappings.update_all(has_left: true)
        render_success(message: 'You have left the room')
      end

      private

      def active_user_group_check
        user_coding_rooms = CodingRoomUserMapping.where(user_id: @current_user.id, has_left: false).pluck(&:coding_room_id)
        CodingRoom.where(id: user_coding_rooms, is_active: true).any?
      end
    end
  end
end
