# frozen_string_literal: true

# Challenges

User.create!(username: 'manish', name: 'Manish Gupta', discord_id: 'abea', password: '123450', email: 'manish1250@gmai.com')
c1 = Challenge.create!(user: User.first, name: 'test1', topic: 'arrays', is_active: true)
c2 = Challenge.create!(user: User.first, name: 'test2', topic: 'tree', is_active: true)
c3 = Challenge.create!(user: User.first, name: 'test3', topic: 'hashmap', is_active: true)
Company.create!(name: 'Google')
Company.create!(name: 'Amazon')
Company.create!(name: 'Microsoft')
CompanyChallengeMapping.create!(company_id: 1, challenge_id: c1.id)
CompanyChallengeMapping.create!(company_id: 1, challenge_id: c2.id)
CompanyChallengeMapping.create!(company_id: 1, challenge_id: c3.id)
CompanyChallengeMapping.create!(company_id: 2, challenge_id: c1.id)
CompanyChallengeMapping.create!(company_id: 2, challenge_id: c2.id)
CompanyChallengeMapping.create!(company_id: 2, challenge_id: c3.id)
CompanyChallengeMapping.create!(company_id: 3, challenge_id: c1.id)
CompanyChallengeMapping.create!(company_id: 3, challenge_id: c2.id)
CompanyChallengeMapping.create!(company_id: 3, challenge_id: c3.id)