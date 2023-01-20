# frozen_string_literal: true

User.create!(username: 'manish', name: 'Manish Gupta', discord_id: 'abea', password: '123450', email: 'manish@gmail.com')
User.create!(username: 'adhikram', name: 'Manish Gupta', discord_id: 'aeofjf', password: '123450', email: 'adhikramm@gmail.com')

Challenge.create(user: User.first, name: 'test1', topic: 'arrays', is_active: true, score: 100)
Challenge.create(user: User.first, name: 'test2', topic: 'tree', is_active: true, score: 100)
Challenge.create(user: User.first, name: 'test3', topic: 'hashmap', is_active: true, score: 100)

CodingRoom.create(name: 'DN-Team', room_time: 1, challenge_list: [1], finish_at: Time.now + 7.days)

CodingRoomUserMapping.create(user_id: User.second_to_last.id, coding_room_id: 4)
CodingRoomUserMapping.create(user_id: User.last.id, coding_room_id: 4)

AlgoSubmission.create(user_id: 1, challenge_id: Challenge.first.id, language: 'cpp', status: 'Accepted', passed_test_cases: 5, total_test_cases: 10, is_submitted: true, coding_room_id: 4)
AlgoSubmission.create(user_id: 1, challenge_id: Challenge.second.id, language: 'cpp', status: 'Accepted', passed_test_cases: 10, total_test_cases: 10, is_submitted: true, coding_room_id: 4)
AlgoSubmission.create(user_id: 1, challenge_id: Challenge.last.id, language: 'cpp', status: 'Accepted', passed_test_cases: 10, total_test_cases: 10, is_submitted: true, coding_room_id: 4)
AlgoSubmission.create(user_id: User.last.id, challenge_id: Challenge.first.id, language: 'cpp', status: 'Accepted', passed_test_cases: 10, total_test_cases: 10, is_submitted: true,coding_room_id: 4)
AlgoSubmission.create(user_id: User.last.id, challenge_id: Challenge.second.id, language: 'cpp', status: 'Accepted', passed_test_cases: 5, total_test_cases: 10, is_submitted: true,coding_room_id: 4)
AlgoSubmission.create(user_id: User.last.id, challenge_id: Challenge.last.id, language: 'cpp', status: 'Accepted', passed_test_cases: 10, total_test_cases: 10, is_submitted: true, coding_room_id: 4)
AlgoSubmission.create(user_id: User.second_to_last.id, challenge_id: Challenge.last.id, language: 'cpp', status: 'Accepted', passed_test_cases: 10, total_test_cases: 10, is_submitted: true,coding_room_id: 4)
