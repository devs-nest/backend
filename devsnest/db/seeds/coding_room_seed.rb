# frozen_string_literal: true

User.create!(username: 'manish', name: 'Manish Gupta', discord_id: 'abea', password: '123450', email: 'manish@gmail.com')
User.create!(username: 'adhikram', name: 'Manish Gupta', discord_id: 'aeofjf', password: '123450', email: 'adhikram@gmail.com')

Challenge.create(user: User.first, name: 'test1', topic: 'arrays', is_active: true, score: 100)
Challenge.create(user: User.first, name: 'test2', topic: 'tree', is_active: true, score: 100)
Challenge.create(user: User.first, name: 'test3', topic: 'hashmap', is_active: true, score: 100)

CodingRoom.create(name: 'CGEC', room_time: 1, challenge_list: [1], finish_at: Time.now + 1.hours)

AlgoSubmission.create(user_id: User.find_by(username: 'adhikram1').id, challenge_id: Challenge.first.id, language: 'cpp', status: 'Accepted', passed_test_cases: 5, total_test_cases: 10, is_submitted: true, coding_room_id: 1)
AlgoSubmission.create(user_id: User.find_by(username: 'adhikram1').id, challenge_id: Challenge.second.id, language: 'cpp', status: 'Accepted', passed_test_cases: 10, total_test_cases: 10, is_submitted: true, coding_room_id: 1)
AlgoSubmission.create(user_id: User.find_by(username: 'adhikram1').id, challenge_id: Challenge.second.id, language: 'cpp', status: 'Accepted', passed_test_cases: 10, total_test_cases: 10, is_submitted: true, coding_room_id: 1)
AlgoSubmission.create(user_id: User.find_by(username: 'adhikram1').id, challenge_id: Challenge.last.id, language: 'cpp', status: 'Accepted', passed_test_cases: 10, total_test_cases: 10, is_submitted: true, coding_room_id: 1)
AlgoSubmission.create(user_id: User.find_by(username: 'manish1').id, challenge_id: Challenge.first.id, language: 'cpp', status: 'Accepted', passed_test_cases: 10, total_test_cases: 10, is_submitted: true, coding_room_id: 1)
AlgoSubmission.create(user_id: User.find_by(username: 'manish1').id, challenge_id: Challenge.second.id, language: 'cpp', status: 'Accepted', passed_test_cases: 5, total_test_cases: 10,is_submitted: true, coding_room_id: 1)
AlgoSubmission.create(user_id: User.find_by(username: 'manish1').id, challenge_id: Challenge.last.id, language: 'cpp', status: 'Accepted', passed_test_cases: 10, total_test_cases: 10, is_submitted: true, coding_room_id: 1)
