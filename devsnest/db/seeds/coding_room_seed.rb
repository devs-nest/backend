# frozen_string_literal: true

User.create!(username: 'manish', name: 'Manish Gupta', discord_id: 'abea', password: '123450', email: 'manish@gmail.com')
User.create!(username: 'adhikram', name: 'Manish Gupta', discord_id: 'aeofjf', password: '123450', email: 'adhikram123@gmail.com')

Challenge.create(user: User.first, name: 'test1', topic: 'arrays', is_active: true, score: 100)
Challenge.create(user: User.first, name: 'test2', topic: 'tree', is_active: true, score: 100)
Challenge.create(user: User.first, name: 'test3', topic: 'hashmap', is_active: true, score: 100)

CodingRoom.create(name: 'DN-Team', room_time: 1, challenge_list: [1,2,3], finish_at: Time.now + 60.minutes, user_id: User.first.id, starts_at: Time.now, difficulty: '[\'easy\']', question_count: 3, topics: '[\'array\']"')

CodingRoomUserMapping.create(user_id: User.last.id, coding_room_id: CodingRoom.last.id)
CodingRoomUserMapping.create(user_id: 1, coding_room_id: CodingRoom.last.id)

AlgoSubmission.create(user_id: 1, challenge_id: Challenge.first.id, language: 'cpp', status: 'Accepted', passed_test_cases: 10, total_test_cases: 10, is_submitted: true, coding_room_id: CodingRoom.last.id)

AlgoSubmission.create(user_id: 1, challenge_id: Challenge.second.id, language: 'cpp', status: 'Accepted', passed_test_cases: 10, total_test_cases: 10, is_submitted: true, coding_room_id: CodingRoom.last.id)
AlgoSubmission.create(user_id: 1, challenge_id: Challenge.third.id, language: 'cpp', status: 'Accepted', passed_test_cases: 10, total_test_cases: 10, is_submitted: true, coding_room_id: CodingRoom.last.id)
AlgoSubmission.create(user_id: User.last.id, challenge_id: Challenge.first.id, language: 'cpp', status: 'Accepted', passed_test_cases: 10, total_test_cases: 10, is_submitted: true,coding_room_id: CodingRoom.last.id)
AlgoSubmission.create(user_id: User.last.id, challenge_id: Challenge.second.id, language: 'cpp', status: 'Accepted', passed_test_cases: 10, total_test_cases: 10, is_submitted: true,coding_room_id: CodingRoom.last.id)
AlgoSubmission.create(user_id: User.last.id, challenge_id: Challenge.third.id, language: 'cpp', status: 'Accepted', passed_test_cases: 10, total_test_cases: 10, is_submitted: true, coding_room_id: CodingRoom.last.id)
AlgoSubmission.create(user_id: User.last.id, challenge_id: Challenge.second.id, language: 'cpp', status: 'Accepted', passed_test_cases: 10, total_test_cases: 10, is_submitted: true,coding_room_id: CodingRoom.last.id)
lb = LeaderboardDevsnest::RoomLeaderboard.new(CodingRoom.last.id.to_s).call
lb.leaders(2, with_member_data: true)