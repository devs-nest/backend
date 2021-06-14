# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# User.create(name: 'manish', email:'manish12@gmail.com', password: '123456')
# User.create(name: 'mohit', email:'manish123@gmail.com', password: '123457')
# User.create(name: 'kohit', email:'manish124@gmail.com', password: '123458')
# User.create(name: 'rohit', email:'manish125@gmail.com', password: '123459')

# #Mmt.create(user_id: 1, mentor_id: 2)

# Content.create(unique_id: 'algo', parent_id: nil, name: 'Algorithims', data_type: 3, link: nil, priority: 0)
# Content.create(unique_id: 'arrays', parent_id: 'algo', name: 'Arrays', data_type: 4, link: nil, priority: 2)
# Content.create(unique_id: 'Q1', parent_id: 'arrays', name: 'Q1', data_type: 0, link: 'https://leetcode.com/problems/palindrome-number/', priority: 3)
# Content.create(unique_id: 'Q2', parent_id: 'arrays', name: 'Q2', data_type: 0, link: 'https://leetcode.com/problems/reverse-bits/', priority: 4)
# Content.create(unique_id: 'warmup', parent_id: 'algo', name: 'Warmup', data_type: 4, link: nil, priority: 1)
# Content.create(unique_id: 'Q3', parent_id: 'warmup', name: nil, data_type: 0, link: 'https://leetcode.com/problems/add-strings/', priority: 5)
# Content.create(unique_id: 'Q4', parent_id: 'warmup', name: nil, data_type: 0, link: 'https://leetcode.com/problems/power-of-four/', priority: 6)
# Content.create(unique_id: 'Q5', parent_id: 'warmup', name: nil, data_type: 0, link: 'https://leetcode.com/problems/convert-to-base-2/', priority: 7)
# Content.create(unique_id: 'Q6', parent_id: 'warmup', name: nil, data_type: 0, link: 'https://leetcode.com/problems/palindrome-number/', priority: 8)

# Content.create(unique_id: 'String', parent_id: 'algo', name: 'String', data_type: 4, link: nil, priority: 9)
# Content.create(unique_id: 'Q7', parent_id: 'String', name: 'Longest Substring Without Repeating Characters', data_type: 0,
#                link: 'https://leetcode.com/problems/longest-substring-without-repeating-characters/', priority: 10)
# Content.create(unique_id: 'Q8', parent_id: 'String', name: 'Valid Anagram', data_type: 0, link: 'https://leetcode.com/problems/valid-anagram', priority: 11)
# Content.create(unique_id: 'Q9', parent_id: 'String', name: 'Group Anagrams', data_type: 0, link: 'https://leetcode.com/problems/group-anagrams/', priority: 12)
# Content.create(unique_id: 'Q10', parent_id: 'String', name: 'Valid Parentheses', data_type: 0, link: 'https://leetcode.com/problems/valid-parentheses/ ', priority: 13)
# Content.create(unique_id: 'Q11', parent_id: 'String', name: 'Valid Palindrome', data_type: 0, link: 'https://leetcode.com/problems/valid-palindrome-ii/ ', priority: 14)
# Content.create(unique_id: 'Q12', parent_id: 'String', name: 'Palindromic Substrings', data_type: 0, link: 'https://leetcode.com/problems/palindromic-substrings/', priority: 15)

# filter get apis
# http://localhost:3000/api/v1/contents/								=>show Algo(default) subtopics

# http://localhost:3000/api/v1/contents?filter[parent_id="String"  =>string question
# http://localhost:3000/api/v1/contents?filter[parent_id="Array"  =>arrays question

# User.create(name: 'manish', discord_id: 'abe', password: '123450', email: 'manish1250@gmail.com')
# User.create(name: 'ajjr', discord_id: 'afd', password: '1234501', email: 'ajjr251@gmail.com')
# User.create(name: 'test', discord_id: 'qwe', password: '1237801', email: 'test@gmail.com')

# User.create(name: 'neha', discord_id: 'bcde', password: '123450', email: 'neha1250@gmail.com')
# User.create(name: 'ayushi', discord_id: 'sbcd', password: '1234501', email: 'ayushi51@gmail.com')
# User.create(name: 'aditi', discord_id: 'qwer', password: '1237801', email: 'aditi@gmail.com')

# User.create(name: 'priya', discord_id: 'ccde', password: '123450', email: 'priya@gmail.com')
# User.create(name: 'pawni', discord_id: 'fbcd', password: '1234501', email: 'pawni1251@gmail.com')
# User.create(name: 'ayush', discord_id: 'bwer', password: '1237801', email: 'ayush@gmail.com')

# User.create(name: 'prachi', discord_id: 'dcde', password: '123450', email: 'prachi1250@gmail.com')
# User.create(name: 'udit', discord_id: 'ebcd', password: '1234501', email: 'udit1251@gmail.com')
# User.create(name: 'vedansh', discord_id: 'ywer', password: '1237801', email: 'vedansh@gmail.com')

# Group.create(owner_id: User.last.id, name: "first one")
# GroupMember.create(user_id: User.first.id, group_id: Group.last.id)
# GroupMember.create(user_id: User.second.id, group_id: Group.last.id)
