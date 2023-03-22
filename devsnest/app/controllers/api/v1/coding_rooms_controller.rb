# frozen_string_literal: true

module Api
  module V1
    class CodingRoomsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth

      def index
        user_coding_room_ids = CodingRoomUserMapping.where(user_id: @current_user.id).pluck(:coding_room_id)
        user_room_details = if user_coding_room_ids.blank?
                              []
                            else
                              CodingRoom.where(id: user_coding_room_ids).select(:id, :unique_id, :name, :starts_at, :topics, :difficulty, :question_count, :room_time, :finish_at, :is_active)
                            end

        all_coding_rooms = CodingRoom.public_rooms.where.not(id: user_coding_room_ids).select(:id, :unique_id, :name, :starts_at, :topics, :difficulty, :question_count, :room_time, :finish_at,
                                                                                              :is_active)
        active_user_rooms = user_room_details.blank? ? [] : user_room_details.where(is_active: true).order('finish_at desc')
        user_rooms = user_room_details.blank? ? [] : user_room_details.where(is_active: false).order('finish_at desc')
        return render_success(message: 'There are no active rooms') if all_coding_rooms.blank? && user_room_details.blank?

        render_success({ active_user_room: active_user_rooms,
                         user_coding_room: user_rooms,
                         coding_rooms: all_coding_rooms.order('finish_at desc') }.as_json)
      end

      def create
        room_params = params.dig(:data, :attributes)
        topics = room_params[:topics]
        difficulty = room_params[:difficulty]
        number_of_questions = room_params[:number_of_questions]
        starts_at = room_params[:starts_at]

        # return render_error(message: 'You are a part of an active coding room') if active_user_group_check

        challenges = Challenge.active.where(topic: topics, difficulty: difficulty).sample(number_of_questions.to_i)
        room_details = CodingRoom.create!(name: room_params[:name], room_time: room_params[:room_time], is_private: room_params[:is_private], challenge_list: challenges.pluck(:id),
                                          user_id: @current_user.id, starts_at: starts_at, question_count: number_of_questions, difficulty: difficulty, topics: topics)

        CodingRoomUserMapping.create!(user_id: @current_user.id, coding_room_id: room_details.id)
        lb = LeaderboardDevsnest::RoomLeaderboard.new(room_details.id.to_s).call
        lb.rank_member(@current_user.username, 0, { 'score' => 0, 'is_active' => true }.to_json)

        render_success(room_details: room_details, challenge_list: challenges)
      end

      def start_room
        coding_room_id = params[:coding_room_id]
        room = CodingRoom.find_by(id: coding_room_id)
        return render_error(message: 'No such Room exists') if room.nil?

        room.update(has_started: true)
        return render_error(message: 'Permission Denied, Ask Room Creater to Start the room') if @current_user.id != room.user_id

        render_success(message: 'The room has started')
      end

      def join_room
        room_code = params[:unique_room_code]
        # return render_error(message: 'You are a part of an active coding room') if active_user_group_check

        room = CodingRoom.find_by(unique_id: room_code)
        return render_error(message: "Room  doesn't exist") if room.nil?

        user_room_mapping = CodingRoomUserMapping.find_by(user_id: @current_user.id, coding_room_id: room.id)

        CodingRoomUserMapping.create!(user_id: @current_user.id, coding_room_id: room.id) unless user_room_mapping.present?
        # user_room_mapping.update!(has_left: false) if user_room_mapping.present? && user_room_mapping.has_left == true
        lb = LeaderboardDevsnest::RoomLeaderboard.new(room.id.to_s).call
        member_data = lb.members_data_for(@current_user.username)[0]
        user_score = lb.score_for(@current_user.username) || 0
        current_score = member_data.present? ? JSON.parse(member_data)['score'] : 0
        lb.rank_member(@current_user.username, user_score, { 'score' => current_score, 'is_active' => true }.to_json)
        render_success(coding_room_id: room.id)
      end

      def show
        user_coding_room = CodingRoomUserMapping.find_by(user_id: @current_user.id, coding_room_id: params[:id])&.coding_room
        return render_error(message: 'You are not a part of this room,Join Room') if user_coding_room.blank?

        user_room_details = CodingRoom.find_by(id: user_coding_room.id).attributes.except("challenge_list")
        remaining_time = (user_coding_room.finish_at.to_i - Time.current.to_i).positive? ? (user_coding_room.finish_at.to_i - Time.current.to_i).seconds : 0
        if Time.now < user_coding_room.starts_at
          return render_success(id: user_coding_room.id, challenge: [], room_details: user_room_details, remaining_time: remaining_time,
                                starts_at: user_coding_room.starts_at)
        end
        challenges = Challenge.where(id: user_coding_room.challenge_list).order(:difficulty)
        render_success(id: user_coding_room.id, challenge: challenges, room_details: user_room_details, remaining_time: remaining_time, starts_at: user_coding_room.starts_at)
      end

      def user_submissions
        coding_room = CodingRoom.find_by(id: params[:id])
        algo_submissions = AlgoSubmission.where(coding_room_id: coding_room.id, user_id: @current_user.id)
        render_success(submissions: algo_submissions)
      end

      def active_user_list
        room_id = params[:id]
        active_users = CodingRoomUserMapping.where(coding_room_id: room_id).count
        render_success(users: active_users.as_json)
      end

      def leave_room
        mapping = CodingRoomUserMapping.find_by(user_id: @current_user.id, coding_room_id: params[:coding_room_id], has_left: false)
        return render_error(message: 'You are not a part of any active room') if mapping.blank?

        lb = LeaderboardDevsnest::RoomLeaderboard.new(params[:coding_room_id].to_s).call
        member_data = lb.members_data_for(@current_user.username)[0]
        current_score = member_data.present? ? JSON.parse(member_data)['score'] : 0
        lb.update_member_data(@current_user.username, { 'score' => current_score, 'is_active' => false }.to_json)
        mapping.update(has_left: true)
        render_success(message: 'You have left the room')
      end

      def leaderboard
        leaderboard = LeaderboardDevsnest::RoomLeaderboard.new(params[:id].to_s).call

        leaderboard.page_size = params[:size].to_i || 10
        member_data = leaderboard.members_data_for(@current_user.username)[0]
        current_score = member_data.present? ? JSON.parse(member_data)['score'] : 0
        page = params[:page].to_i

        data = {
          id: page,
          type: "#{params[:id]}_leaderboard",
          current_user: { name: @current_user.username, score: current_score, rank: leaderboard.rank_for(@current_user.username) },
          scoreboard: leaderboard.leaders(page, with_member_data: true),
          count: leaderboard.total_pages
        }
        render_success(data)
      end

      def update_room_details
        params.require(:data).permit(attributes: %i[name id])
        coding_room = CodingRoom.find_by(id: params[:data][:attributes][:id])
        return render_error(message: 'Room Does not exists') if coding_room.blank?
        return render_error(message: 'Permission Denied, Ask Room Creater to update the room') if @current_user.id != coding_room.user_id

        coding_room.update!(name: params[:data][:attributes][:name])
        render_success(message: 'Room Details Updated')
      end

      private

      def active_user_group_check
        user_coding_rooms = CodingRoomUserMapping.where(user_id: @current_user.id, has_left: false).pluck(&:coding_room_id)
        CodingRoom.where(id: user_coding_rooms, is_active: true).any?
      end
    end
  end
end
