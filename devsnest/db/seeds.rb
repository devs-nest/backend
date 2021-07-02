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
# Content.create(unique_id: 'link1', parent_id: 'arrays', name: 'DSA DAY 4', data_type: 1, link: 'https://youtube.com/someting', priority: 4, video_questions: [3,4])
# Content.create(unique_id: 'link2', parent_id: 'arrays', name: 'DSA DAY 3', data_type: 1, link: 'https://youtube.com/sometings', priority: 4)
# # Content.create(unique_id: 'ref-array', parent_id: 'link1', name: 'what is prefix sum', data_type: 2, link: 'https://en.wikipedia.org/wiki/Prefix_sum', priority: 4)
# # Content.create(unique_id: 'ref-array2', parent_id: 'link1', name: 'prefix sum implementation', data_type: 5, link: 'https://www.geeksforgeeks.org/prefix-sum-array-implementation-applications-competitive-programming/', priority: 4)
# Content.create(unique_id: 'bst', parent_id: 'algo', name: 'Binary search tree', data_type: 4, link: nil, priority: 1)
# Content.create(unique_id: 'Q3', parent_id: 'bst', name:'Q3' , data_type: 0, link: 'https://leetcode.com/problems/add-strings/', priority: 5)
# Content.create(unique_id: 'Q4', parent_id: 'bst', name: 'Q4' , data_type: 0, link: 'https://leetcode.com/problems/power-of-four/', priority: 6)
# Content.create(unique_id: 'link3', parent_id: 'bst', name: 'yt_link3', data_type: 1, link: 'https://youtube.com/sometingsss', priority: 4, video_questions: [9,10])
# Content.create(unique_id: 'ref-bst', parent_id: 'link2', name: 'what is prefix sum', data_type: 2, link: 'https://cp-algorithms.com/data_structures/segment_tree.html', priority: 4)
# Content.create(unique_id: 'ref-bst2', parent_id: 'link2', name: 'prefix sum implementation', data_type: 5, link: 'https://www.geeksforgeeks.org/segment-tree-set-1-sum-of-given-range/', priority: 4)
# Content.create(unique_id: 'link4', parent_id: 'bst', name: 'yt_link4', data_type: 1, link: 'https://youtube.com/sometingsssss', priority: 4)
# Content.create(unique_id: 'dp', parent_id: 'algo', name: 'Dynamic programming', data_type: 4, link: nil, priority: 1)
# Content.create(unique_id: 'Q5', parent_id: 'dp', name: 'Q5', data_type: 0, link: 'https://leetcode.com/problems/convert-to-base-2/', priority: 7)
# Content.create(unique_id: 'Q6', parent_id: 'dp', name: 'Q6', data_type: 0, link: 'https://leetcode.com/problems/palindrome-number/', priority: 8)
# Content.create(unique_id: 'link5', parent_id: 'dp', name: 'yt_link5', data_type: 1, youtube_link: 'https://youtube.com/helloxyz', priority: 4)
# Content.create(unique_id: 'link6', parent_id: 'dp', name: 'yt_link6', data_type: 1, youtube_link: 'https://youtube.com/subscribeplis', priority: 4)

Content.create(unique_id: 'fend', parent_id: nil, name: 'frontend', data_type: 3, link: nil, priority: 0)
Content.create(unique_id: 'html', parent_id: 'fend', name: 'HTML', data_type: 4, link: nil, priority: 1)
Content.create(unique_id: 'YT1', parent_id: 'html', name: 'Frontend Day 1 - Introduction to HTML', data_type: 1, link: 'https://www.youtube.com/watch?v=KnZa_Ri_B18&t=1378s', priority: 2, video_questions: [14])
Content.create(unique_id: 'css', parent_id: 'fend', name: 'Css', data_type: 4, link: nil, priority: 3)
Content.create(unique_id: 'YT2', parent_id: 'css', name: 'Frontend Day 2 - Introduction to CSS', data_type: 1, link: 'https://www.youtube.com/watch?v=porf5cZwExI', priority: 4, video_questions: [15])
Content.create(unique_id: 'YT3', parent_id: 'css', name: 'Frontend Day 3 - Continuing with CSS', data_type: 1, link: 'https://www.youtube.com/watch?v=EmXf7YcFmhs&t=2096s', priority: 5, video_questions: [16])
Content.create(unique_id: 'YT4', parent_id: 'css', name: 'Frontend Day 4 - Positions | Display | Overflow', data_type: 1, link: 'https://www.youtube.com/watch?v=Tl2yie4qDLQ&t=2550s', priority: 6, video_questions: [17])
Content.create(unique_id: 'js', parent_id: 'fend', name: 'Javascript', data_type: 4, link: nil, priority: 7)
Content.create(unique_id: 'YT5', parent_id: 'js', name: 'Frontend Day 5 - Introduction to Javascript', data_type: 1, link: 'https://www.youtube.com/watch?v=KCPkrGCq9B8&t=3707s' ,priority: 8)
Content.create(unique_id: 'YT6', parent_id: 'js', name: 'Frontend Day 6 - Arrays | Introduction to Javascript', data_type: 1, link: 'https://www.youtube.com/watch?v=Yxj54m8dGNg', priority: 9, video_questions: [18])
Content.create(unique_id: 'YT7', parent_id: 'js', name: 'Frontend Day 7 - Objects | Introduction to Javascript', data_type: 1, link: 'https://www.youtube.com/watch?v=_eSDbbGmgAU', priority: 10, video_questions: [19])
Content.create(unique_id: 'YT8', parent_id: 'js', name: 'Frontend Day 8 - Objects | Introduction to Javascript', data_type: 1, link: 'https://www.youtube.com/watch?v=2eDK5zWjR64&t=5s', priority: 11, video_questions: [20])
Content.create(unique_id: 'YT9', parent_id: 'js', name: 'Frontend Day 9 | this Keyword | Call | Apply | Bind', data_type: 1, link: 'https://www.youtube.com/watch?v=j9gacsYnjWE', priority: 12, video_questions: [21])

Content.create(unique_id: 'Q1', parent_id: 'YT1', name: 'question 1', data_type: 0, link: 'https://drive.google.com/file/d/1KiZnTNhUaQpeIkRcvvsbGrR1SxF9Urhf/view', priority: 13)
Content.create(unique_id: 'Q2', parent_id: 'YT2', name: 'question 2', data_type: 0, link: 'https://drive.google.com/file/d/1KiZnTNhUaQpeIkRcvvsbGrR1SxF9Urhf/view', priority: 14)
Content.create(unique_id: 'Q3', parent_id: 'YT3', name: 'question 3', data_type: 0, link: 'https://drive.google.com/file/d/1htU3hI1chl4dPbxKuwp7SxM6UsQ5fyMF/view', priority: 15)
Content.create(unique_id: 'Q4', parent_id: 'YT4', name: 'question 4', data_type: 0, link: 'https://drive.google.com/file/d/1P08tbZMr_7A2y46rRsFQWEGEyqIZhuQ8/view', priority: 16)
Content.create(unique_id: 'Q5', parent_id: 'YT6', name: 'question 5', data_type: 0, link: 'https://docs.google.com/document/d/1ocDYa2B27H2tZVI7f_i-7Ze6SIX_2g2N-jUJJ9t__0g/edit', priority: 17)
Content.create(unique_id: 'Q6', parent_id: 'YT7', name: 'question 6', data_type: 0, link: 'https://docs.google.com/document/d/1ElC4HVna2FO6SqeSd2zuUEuIC2CnnQQqsnOTpL9hydk/edit', priority: 18)
Content.create(unique_id: 'Q7', parent_id: 'YT8', name: 'question 7', data_type: 0, link: 'https://100dayscss.com/?dayIndex=46', priority: 19)
Content.create(unique_id: 'Q8', parent_id: 'YT9', name: 'question 8', data_type: 0, link: 'https://docs.google.com/document/d/1guR5EqC4HzMyfgBxr8z_U_EM0ZNDJZsBLg__taRSnOA/edit', priority: 20)




Content.create(unique_id: 'algo', parent_id: nil, name: 'Algorithims', data_type: 3, link: nil, priority: 21)
Content.create(unique_id: 'arrays', parent_id: 'algo', name: 'Arrays', data_type: 4, link: nil, priority: 22)
Content.create(unique_id: 'Q9', parent_id: 'arrays', name: 'Two Sum', data_type: 0, difficulty: 0, question_type: 0, link: 'https://leetcode.com/problems/two-sum/', priority: 23)
Content.create(unique_id: 'Q10', parent_id: 'arrays', name: ' Product of Array Except Self', data_type: 0, difficulty: 0, question_type: 1, link: 'https://leetcode.com/problems/product-of-array-except-self/', priority: 24)
Content.create(unique_id: 'Q11', parent_id: 'arrays', name: 'Best Time to Buy and Sell Stock', data_type: 0, difficulty: 0, question_type: 0, link: 'https://leetcode.com/problems/best-time-to-buy-and-sell-stock/', priority: 25)
Content.create(unique_id: 'Q12', parent_id: 'arrays', name: 'Median of Two Sorted Arrays', data_type: 0, difficulty: 2, question_type: 1, link: 'https://leetcode.com/problems/median-of-two-sorted-arrays/', priority: 26)
Content.create(unique_id: 'YT12', parent_id: 'arrays', name: 'DSA | Day 1 | Arrays | Two Sum , Best Time to Buy and Sell Stock', data_type: 1, link: 'https://www.youtube.com/watch?v=OSQk34Rtgx0', priority: 27, video_questions: [24,25,26,27] )
Content.create(unique_id: 'bst', parent_id: 'algo', name: 'Arrays', data_type: 4, link: nil, priority: 22)
Content.create(unique_id: 'Q13', parent_id: 'bst', name: 'Two Sum', data_type: 0, difficulty: 0, question_type: 0, link: 'https://leetcode.com/problems/two-sum/', priority: 23)
Content.create(unique_id: 'Q14', parent_id: 'bst', name: ' Product of Array Except Self', data_type: 0, difficulty: 0, question_type: 1, link: 'https://leetcode.com/problems/product-of-array-except-self/', priority: 24)
Content.create(unique_id: 'Q15', parent_id: 'bst', name: 'Best Time to Buy and Sell Stock', data_type: 0, difficulty: 0, question_type: 0, link: 'https://leetcode.com/problems/best-time-to-buy-and-sell-stock/', priority: 25)
Content.create(unique_id: 'Q16', parent_id: 'bst', name: 'Median of Two Sorted Arrays', data_type: 0, difficulty: 2, question_type: 1, link: 'https://leetcode.com/problems/median-of-two-sorted-arrays/', priority: 26)
Content.create(unique_id: 'YT11', parent_id: 'bst', name: 'DSA | Day 12 | BST | QuestionXYZ', data_type: 1, link: 'https://www.youtube.com/watch?v=kp1qG3OhqlE', priority: 27, video_questions: [30,31,32,33])
# Content.create(unique_id: 'link2', parent_id: 'arrays', name: 'DSA | Day 2 | Time Complexities', data_type: 1, link: 'https://www.youtube.com/watch?v=XGyR_BKBSmg', priority: 4, video_questions: [5,6], reference_data: [{"link":"https://www.geeksforgeeks.org/understanding-time-complexity-simple-examples/","type":"article","title":"Understanding Time Complexity"}])
















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

# Group.create(owner_id: User.last.id, name: 'first one')
# Group.create(owner_id: 2, name: 'sec one')
# GroupMember.create(user_id: User.first.id, group_id: Group.last.id)
