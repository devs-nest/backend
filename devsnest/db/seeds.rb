# frozen_string_literal: true

# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
# #
# # Examples:
# #
# #   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
# #   Character.create(name: 'Luke', movie: movies.first)
# # User.create(name: 'manish', email:'manish12@gmail.com', password: '123456')
# # User.create(name: 'mohit', email:'manish123@gmail.com', password: '123457')
# # User.create(name: 'kohit', email:'manish124@gmail.com', password: '123458')
# # User.create(name: 'rohit', email:'manish125@gmail.com', password: '123459')

# # #Mmt.create(user_id: 1, mentor_id: 2)

# Login first and then SEED the file

# Frontend Content

Content.create(unique_id: 'frontend', parent_id: nil, name: 'Frontend', data_type: 3, link: nil, priority: 0)
Content.create(unique_id: 'html', parent_id: 'frontend', name: 'HTML', data_type: 4, link: nil, priority: 1)
Content.create(unique_id: 'YT1', parent_id: 'html', name: 'Frontend Day 1 - Introduction to HTML', data_type: 1, link: 'https://www.youtube.com/watch?v=KnZa_Ri_B18&t=1378s', priority: 2,
               video_questions: [14])
Content.create(unique_id: 'css', parent_id: 'frontend', name: 'Css', data_type: 4, link: nil, priority: 3)
Content.create(unique_id: 'YT2', parent_id: 'css', name: 'Frontend Day 2 - Introduction to CSS', data_type: 1, link: 'https://www.youtube.com/watch?v=porf5cZwExI', priority: 4,
               video_questions: [15])
Content.create(unique_id: 'YT3', parent_id: 'css', name: 'Frontend Day 3 - Continuing with CSS', data_type: 1, link: 'https://www.youtube.com/watch?v=EmXf7YcFmhs&t=2096s', priority: 5,
               video_questions: [16])
Content.create(unique_id: 'YT4', parent_id: 'css', name: 'Frontend Day 4 - Positions | Display | Overflow', data_type: 1, link: 'https://www.youtube.com/watch?v=Tl2yie4qDLQ&t=2550s', priority: 6,
               video_questions: [17])
Content.create(unique_id: 'js', parent_id: 'frontend', name: 'Javascript', data_type: 4, link: nil, priority: 7)
Content.create(unique_id: 'YT5', parent_id: 'js', name: 'Frontend Day 5 - Introduction to Javascript', data_type: 1, link: 'https://www.youtube.com/watch?v=KCPkrGCq9B8&t=3707s', priority: 8)
Content.create(unique_id: 'YT6', parent_id: 'js', name: 'Frontend Day 6 - Arrays | Introduction to Javascript', data_type: 1, link: 'https://www.youtube.com/watch?v=Yxj54m8dGNg', priority: 9,
               video_questions: [18])
Content.create(unique_id: 'YT7', parent_id: 'js', name: 'Frontend Day 7 - Objects | Introduction to Javascript', data_type: 1, link: 'https://www.youtube.com/watch?v=_eSDbbGmgAU', priority: 10,
               video_questions: [19])
Content.create(unique_id: 'YT8', parent_id: 'js', name: 'Frontend Day 8 - Objects | Introduction to Javascript', data_type: 1, link: 'https://www.youtube.com/watch?v=2eDK5zWjR64&t=5s',
               priority: 11, video_questions: [20])
Content.create(unique_id: 'YT9', parent_id: 'js', name: 'Frontend Day 9 | this Keyword | Call | Apply | Bind', data_type: 1, link: 'https://www.youtube.com/watch?v=j9gacsYnjWE', priority: 12,
               video_questions: [21])

# DSA Content

Content.create(unique_id: 'Q1', parent_id: 'html', name: 'question 1', data_type: 0, link: 'https://drive.google.com/file/d/1KiZnTNhUaQpeIkRcvvsbGrR1SxF9Urhf/view', priority: 13)
Content.create(unique_id: 'Q2', parent_id: 'css', name: 'question 2', data_type: 0, link: 'https://drive.google.com/file/d/1KiZnTNhUaQpeIkRcvvsbGrR1SxF9Urhf/view', priority: 14)
Content.create(unique_id: 'Q3', parent_id: 'css', name: 'question 3', data_type: 0, link: 'https://drive.google.com/file/d/1htU3hI1chl4dPbxKuwp7SxM6UsQ5fyMF/view', priority: 15)
Content.create(unique_id: 'Q4', parent_id: 'css', name: 'question 4', data_type: 0, link: 'https://drive.google.com/file/d/1P08tbZMr_7A2y46rRsFQWEGEyqIZhuQ8/view', priority: 16)
Content.create(unique_id: 'Q5', parent_id: 'js', name: 'question 5', data_type: 0, link: 'https://docs.google.com/document/d/1ocDYa2B27H2tZVI7f_i-7Ze6SIX_2g2N-jUJJ9t__0g/edit', priority: 17)
Content.create(unique_id: 'Q6', parent_id: 'js', name: 'question 6', data_type: 0, link: 'https://docs.google.com/document/d/1ElC4HVna2FO6SqeSd2zuUEuIC2CnnQQqsnOTpL9hydk/edit', priority: 18)
Content.create(unique_id: 'Q7', parent_id: 'js', name: 'question 7', data_type: 0, link: 'https://100dayscss.com/?dayIndex=46', priority: 19)
Content.create(unique_id: 'Q8', parent_id: 'js', name: 'question 8', data_type: 0, link: 'https://docs.google.com/document/d/1guR5EqC4HzMyfgBxr8z_U_EM0ZNDJZsBLg__taRSnOA/edit', priority: 20)

Content.create(unique_id: 'algo', parent_id: nil, name: 'Algorithims', data_type: 3, link: nil, priority: 21)
Content.create(unique_id: 'arrays', parent_id: 'algo', name: 'Arrays', data_type: 4, link: nil, priority: 22)
Content.create(unique_id: 'Q9', parent_id: 'arrays', name: 'Two Sum', data_type: 0, difficulty: 0, question_type: 0, link: 'https://leetcode.com/problems/two-sum/', priority: 23)
Content.create(unique_id: 'Q10', parent_id: 'arrays', name: ' Product of Array Except Self', data_type: 0, difficulty: 0, question_type: 1,
               link: 'https://leetcode.com/problems/product-of-array-except-self/', priority: 24)
Content.create(unique_id: 'Q11', parent_id: 'arrays', name: 'Best Time to Buy and Sell Stock', data_type: 0, difficulty: 0, question_type: 0,
               link: 'https://leetcode.com/problems/best-time-to-buy-and-sell-stock/', priority: 25)
Content.create(unique_id: 'Q12', parent_id: 'arrays', name: 'Valid Sudoku', data_type: 0, difficulty: 1, question_type: 1,
               link: 'https://leetcode.com/problems/valid-sudoku/', priority: 26)
Content.create(unique_id: 'YT12', parent_id: 'arrays', name: 'DSA | Day 1 | Arrays | Two Sum , Best Time to Buy and Sell Stock', data_type: 1, link: 'https://www.youtube.com/watch?v=OSQk34Rtgx0',
               priority: 27, video_questions: [24, 25, 26, 27])
Content.create(unique_id: 'bst', parent_id: 'algo', name: 'Arrays', data_type: 4, link: nil, priority: 22)
Content.create(unique_id: 'Q13', parent_id: 'bst', name: 'Two Sum', data_type: 0, difficulty: 0, question_type: 0, link: 'https://leetcode.com/problems/two-sum/', priority: 23)
Content.create(unique_id: 'Q14', parent_id: 'bst', name: ' Product of Array Except Self', data_type: 0, difficulty: 0, question_type: 1,
               link: 'https://leetcode.com/problems/product-of-array-except-self/', priority: 24)
Content.create(unique_id: 'Q15', parent_id: 'bst', name: 'Best Time to Buy and Sell Stock', data_type: 0, difficulty: 0, question_type: 0,
               link: 'https://leetcode.com/problems/best-time-to-buy-and-sell-stock/', priority: 25)
Content.create(unique_id: 'Q16', parent_id: 'bst', name: 'Median of Two Sorted Arrays', data_type: 0, difficulty: 2, question_type: 1,
               link: 'https://leetcode.com/problems/median-of-two-sorted-arrays/', priority: 26)
Content.create(unique_id: 'YT11', parent_id: 'bst', name: 'DSA | Day 12 | BST | QuestionXYZ', data_type: 1, link: 'https://www.youtube.com/watch?v=kp1qG3OhqlE', priority: 27,
               video_questions: [30, 31, 32, 33])

# Users

User.create(name: 'manish', username: 'Manish Gupta', discord_id: 'abe', password: '123450', email: 'manish1250@gmail.com')
User.create(name: 'Amit', username: 'Ajjr Mishra', discord_id: 'afd', password: '1234501', email: 'ajjr251@gmail.com')
User.create(name: 'Ramesh', username: 'Ramesh Sharma', discord_id: 'qwe', password: '1237801', email: 'test@gmail.com')
User.create(name: 'neha', username: 'Neha Arora', discord_id: 'bcde', password: '123450', email: 'neha1250@gmail.com')

User.create(name: 'ayushi', username: 'Ayushi Poonia', discord_id: 'sbcd', password: '1234501', email: 'ayushi51@gmail.com')
User.create(name: 'aditi', username: 'Aditi Gupta', discord_id: 'qwer', password: '1237801', email: 'aditi@gmail.com')
User.create(name: 'priya', username: 'Priya Patra', discord_id: 'ccde', password: '123450', email: 'priya@gmail.com')
User.create(name: 'pawni', username: 'Pawni Sharma', discord_id: 'fbcd', password: '1234501', email: 'pawni1251@gmail.com')

User.create(name: 'ayush', username: 'Ayush Chand', discord_id: 'bwer', password: '1237801', email: 'ayush@gmail.com')
User.create(name: 'prachi', username: 'Prachi Raman', discord_id: 'dcde', password: '123450', email: 'prachi1250@gmail.com')
User.create(name: 'udit', username: 'Udit Narayan', discord_id: 'ebcd', password: '1234501', email: 'udit1251@gmail.com')
User.create(name: 'vedansh', username: 'Vedansh Garg', discord_id: 'ywer', password: '1237801', email: 'vedansh@gmail.com')

User.create(name: 'yug', username: 'Yug Gurnani', discord_id: 'ccde', password: '123450', email: 'yug@gmail.com')
User.create(name: 'kaydee', username: 'Kshitij Dhama', discord_id: 'fbcd', password: '1234501', email: 'kd@gmail.com')
User.create(name: 'adhikram', username: 'Adhikram Maitra', discord_id: 'bwer', password: '1237801', email: 'adhikram@gmail.com')
User.create(name: 's2r2', username: 'Sanjay Bhaiya', discord_id: 'dcde', password: '123450', email: 's2r2@gmail.com')

User.create(name: 'lakshit', username: 'Lakshit K. Singh', discord_id: 'ebcd', password: '1234501', email: 'lakshit@gmail.com')
User.create(name: 'pathetic', username: 'Pathetic Geek', discord_id: 'ywer', password: '1237801', email: 'pathetic@gmail.com')
User.create(name: 'Araika', username: 'Araika didi', discord_id: 'ebcd', password: '1234501', email: 'araika@gmail.com')
User.create(name: 'Haider', username: 'Haider Pro', discord_id: 'ywer', password: '1237801', email: 'haider@gmail.com')

# Groups

Group.create(owner_id: User.last.id, co_owner_id: User.first.id, name: 'Alpha Team')
Group.create(owner_id: 2, co_owner_id: 4, name: 'Beta Team')
Group.create(owner_id: 8, co_owner_id: 11, name: 'Gamma Team')
Group.create(owner_id: 20, co_owner_id: 17, name: 'Sigma Team')

# Group members

GroupMember.create(user_id: 1, group_id: 1)
GroupMember.create(user_id: 18, group_id: 1)
GroupMember.create(user_id: 6, group_id: 1)
GroupMember.create(user_id: 7, group_id: 1)
GroupMember.create(user_id: 19, group_id: 1)

GroupMember.create(user_id: 2, group_id: 2)
GroupMember.create(user_id: 4, group_id: 2)
GroupMember.create(user_id: 5, group_id: 2)
GroupMember.create(user_id: 12, group_id: 2)
GroupMember.create(user_id: 13, group_id: 2)

GroupMember.create(user_id: 8, group_id: 3)
GroupMember.create(user_id: 11, group_id: 3)
GroupMember.create(user_id: 14, group_id: 3)
GroupMember.create(user_id: 15, group_id: 3)
GroupMember.create(user_id: 16, group_id: 3)

GroupMember.create(user_id: 20, group_id: 4)
GroupMember.create(user_id: 17, group_id: 4)
GroupMember.create(user_id: 21, group_id: 4)
GroupMember.create(user_id: 9, group_id: 4)
GroupMember.create(user_id: 3, group_id: 4)

# for making the user 'ADMIN'

User.first.update(user_type: 1)

# Batch leaders

Group.first.update(batch_leader_id: 1)
Group.last.update(batch_leader_id: 4)
Group.second.update(batch_leader_id: 16)
Group.third.update(batch_leader_id: 14)

# Submissions
Submission.create(user_id: 1, content_id: 24, status: 0, created_at: '2021-03-05 17:03:30.930498', updated_at: '2021-03-05 17:03:30.930498')
Submission.create(user_id: 1, content_id: 25, status: 0, created_at: '2021-03-05 17:03:30.930498', updated_at: '2021-03-05 17:03:30.930498')
Submission.create(user_id: 1, content_id: 26, status: 0, created_at: '2021-04-05 17:03:30.930498', updated_at: '2021-04-05 17:03:30.930498')
Submission.create(user_id: 1, content_id: 27, status: 0, created_at: '2021-04-05 17:03:30.930498', updated_at: '2021-04-05 17:03:30.930498')
Submission.create(user_id: 1, content_id: 29, status: 0, created_at: '2021-05-05 17:03:30.930498', updated_at: '2021-05-05 17:03:30.930498')
