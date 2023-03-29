# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Coding Room Spec', type: :request do
  context 'Get Coding rooms' do
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let!(:coding_room) { create(:coding_room, user_id: user.id, is_private: false, is_active: true, has_started: true, starts_at: Time.now, question_count: 2) }
    let!(:coding_room2) { create(:coding_room, user_id: user.id, is_private: false, is_active: true, has_started: true, starts_at: (Time.now + 1000), question_count: 2) }
    let(:question) { create(:challenge, user_id: user.id, name: 'two sum') }
    let(:algo_submission) { create(:algo_submission, user_id: user.id, challenge_id: question.id) }
    let!(:test) { create(:testcase, challenge_id: question.id, input_path: 'example/ipath', output_path: 'example/opath') }

    it 'should return all Coding rooms when exists' do
      sign_in(user)
      get '/api/v1/coding-rooms'
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['data']['attributes']['coding_rooms']).to be_present
      expect(JSON.parse(response.body)['data']['attributes']['coding_rooms'].count).to eq(2)
    end

    it "should return user's active room and the remaing rooms" do
      sign_in(user)
      CodingRoomUserMapping.create!(coding_room_id: coding_room.id, user_id: user.id)
      get '/api/v1/coding-rooms'
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['data']['attributes']['active_user_room']).to be_present
      expect(JSON.parse(response.body)['data']['attributes']['active_user_room'].count).to eq(1)
      expect(JSON.parse(response.body)['data']['attributes']['active_user_room'][0]['id']).to eq(coding_room.id)
      expect(JSON.parse(response.body)['data']['attributes']['active_user_room'][0]['name']).to eq(coding_room.name)
    end

    it 'should get the coding room by id if user is in active room' do
      sign_in(user)
      CodingRoomUserMapping.create!(coding_room_id: coding_room.id, user_id: user.id)
      get "/api/v1/coding-rooms/#{coding_room.id}"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['data']['attributes']['id']).to eq(coding_room.id)
      expect(JSON.parse(response.body)['data']['attributes']['room_details']['name']).to eq(coding_room.name)
    end

    it 'should directly return the room details if starts at > current time' do
      sign_in(user)
      CodingRoomUserMapping.create!(coding_room_id: coding_room2.id, user_id: user.id)
      get "/api/v1/coding-rooms/#{coding_room2.id}"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['data']['attributes']['id']).to eq(coding_room2.id)
      expect(JSON.parse(response.body)['data']['attributes']['room_details']['name']).to eq(coding_room2.name)
    end

    it 'should return error if user is not a part of that room' do
      sign_in(user)
      get "/api/v1/coding-rooms/#{coding_room.id}"
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body)['data']['attributes']['error']['message']).to eq('You are not a part of this room,Join Room')
    end

    it 'should success in creating room by a user' do
      sign_in(user)
      post '/api/v1/coding-rooms', params: { 'data': { 'type': 'coding_rooms', 'attributes': { 'name': 'test', 'is_private': false, 'is_active': true, 'has_started': true, 'starts_at': Time.now, 'number_of_questions': 1, 'difficulty': 2, 'topics': 1 } } }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['data']['attributes']['room_details']['id']).to be_present
      expect(JSON.parse(response.body)['data']['attributes']['room_details']['name']).to eq('test')
    end

    it 'should start a coding room' do
      sign_in(user)
      put "/api/v1/coding-rooms/start_room?coding_room_id=#{coding_room.id}"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['data']['attributes']['message']).to eq('The room has started')
    end

    it 'should success joining a room' do
      sign_in(user)
      post "/api/v1/coding-rooms/join_room?unique_room_code=#{coding_room.unique_id}"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['data']['attributes']['coding_room_id']).to eq(coding_room.id)
    end

    it 'should success leaving a room' do
      sign_in(user)
      CodingRoomUserMapping.create!(coding_room_id: coding_room.id, user_id: user.id)
      put "/api/v1/coding-rooms/leave_room?coding_room_id=#{coding_room.id}"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)['data']['attributes']['message']).to eq('You have left the room')
    end

    it 'should return active user list for a room' do
      sign_in(user)
      get "/api/v1/coding-rooms/#{coding_room.id}/user_submissions"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to be_present
    end

    it 'should return leaderboard for a room' do
      sign_in(user)
      CodingRoomUserMapping.create!([{ coding_room_id: coding_room.id, user_id: user.id }, { coding_room_id: coding_room.id, user_id: user2.id }])
      get "/api/v1/coding-rooms/leaderboard?id=#{coding_room.id}"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to be_present
      expect(JSON.parse(response.body)['data']['type']).to eq("#{coding_room.id}_leaderboard")
    end

    it "should return a user's submissions for a coding room" do
      sign_in(user)
      CodingRoomUserMapping.create!([{ coding_room_id: coding_room.id, user_id: user.id }, { coding_room_id: coding_room.id, user_id: user2.id }])
      user_count = CodingRoomUserMapping.where(coding_room_id: coding_room.id).count
      get "/api/v1/coding-rooms/#{coding_room.id}/active_user_list"
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)).to be_present
      expect(JSON.parse(response.body)['data']['attributes']['users']).to eq(user_count)
    end
  end
end
