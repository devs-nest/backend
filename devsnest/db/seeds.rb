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

User.create(username: 'manish', name: 'Manish Gupta', discord_id: 'abe', password: '123450', email: 'manish1250@gmail.com')
User.create(username: 'Amit', name: 'Ajjr Mishra', discord_id: 'afd', password: '1234501', email: 'ajjr251@gmail.com')
User.create(username: 'Ramesh', name: 'Ramesh Sharma', discord_id: 'qwe', password: '1237801', email: 'test@gmail.com')
User.create(username: 'neha', name: 'Neha Arora', discord_id: 'bcde', password: '123450', email: 'neha1250@gmail.com')

User.create(username: 'ayushi', name: 'Ayushi Poonia', discord_id: 'sbcd', password: '1234501', email: 'ayushi51@gmail.com')
User.create(username: 'aditi', name: 'Aditi Gupta', discord_id: 'qwer', password: '1237801', email: 'aditi@gmail.com')
User.create(username: 'priya', name: 'Priya Patra', discord_id: 'ccde', password: '123450', email: 'priya@gmail.com')
User.create(username: 'pawni', name: 'Pawni Sharma', discord_id: 'fbcd', password: '1234501', email: 'pawni1251@gmail.com')

User.create(username: 'ayush', name: 'Ayush Chand', discord_id: 'bwer', password: '1237801', email: 'ayush@gmail.com')
User.create(username: 'prachi', name: 'Prachi Raman', discord_id: 'dcde', password: '123450', email: 'prachi1250@gmail.com')
User.create(username: 'udit', name: 'Udit Narayan', discord_id: 'ebcd', password: '1234501', email: 'udit1251@gmail.com')
User.create(username: 'vedansh', name: 'Vedansh Garg', discord_id: 'ywer', password: '1237801', email: 'vedansh@gmail.com')

User.create(username: 'yug', name: 'Yug Gurnani', discord_id: 'ccde', password: '123450', email: 'yug@gmail.com')
User.create(username: 'kaydee', name: 'Kshitij Dhama', discord_id: 'fbcd', password: '1234501', email: 'kd@gmail.com')
User.create(username: 'adhikram', name: 'Adhikram Maitra', discord_id: 'bwer', password: '1237801', email: 'adhikram@gmail.com')
User.create(username: 's2r2', name: 'Sanjay Bhaiya', discord_id: 'dcde', password: '123450', email: 's2r2@gmail.com')

User.create(username: 'lakshit', name: 'Lakshit K. Singh', discord_id: 'ebcd', password: '1234501', email: 'lakshit@gmail.com')
User.create(username: 'pathetic', name: 'Pathetic Geek', discord_id: 'ywer', password: '1237801', email: 'pathetic@gmail.com')
User.create(username: 'Araika', name: 'Araika didi', discord_id: 'ebcd', password: '1234501', email: 'araika@gmail.com')
User.create(username: 'Haider', name: 'Haider Pro', discord_id: 'ywer', password: '1237801', email: 'haider@gmail.com')

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

# Hackathons
Hackathon.create(
  "title": 'Brick Breaker Game',
  "tagline": 'For this hackathon we are going to create a brick breaker game.',
  "reference": 'https://poki.com/en/g/brick-breaker',
  "description": "So go wild with your ideas. But keep it intuitive and fun!\n\nSome ideas which could be included are : having 5 levels or more , score given based on performance , audio effects , power ups! etc (nothing is compulsory. so do it only if you think you can pull it off).",
  "image": 'https://cdn.discordapp.com/attachments/849976559796224069/879808793410699274/unknown.png',
  "leaderboard": {
    "data": [
      {
        "rank": 1,
        "members": [
          'Ayan Dhara',
          'Grawish Sachdeva',
          'Tanmay Vaish',
          'Dhruv Garg',
          'Azhar',
          'Sarvesh Patil',
          'Anjali Goswami'
        ],
        "team_name": 'Untitled Team',
        "project_link": 'https://untitled-team-101.github.io/Bricks-Breaker/'
      },
      {
        "rank": 2,
        "members": [
          'Sanskar Chaware',
          'Kaushik Vrudhula',
          'Swanand Buva',
          'Ritik Gour',
          'Sanket Itnal'
        ],
        "team_name": 'KND Team',
        "project_link": 'https://knd-devsnest.github.io/hack-brick-B/home.html'
      },
      {
        "rank": 3,
        "members": [
          'Shrey Sinha',
          'Srishti Pawar',
          'Pranav Bansal',
          'Shreyash Singh',
          'Pratham Garg',
          'Shivam Kumar Singh',
          'Umang Aggarwal',
          'Taha Jamal'
        ],
        "team_name": '8-bit coders',
        "project_link": 'https://shreyashsingh-101.github.io/Devsnest-Hackathon-/game.html'
      },
      {
        "rank": 4,
        "members": %w[
          Akhil
          Araika
          Chaitanya
          Deepak
          Ankit
          Imtesaal
          Rajat
          Naman
        ],
        "team_name": 'Undefined Team',
        "project_link": 'https://undefined-brickbreaker.netlify.app/levels/lvl2/game.html'
      },
      {
        "rank": 5,
        "members": [
          'Zaheer Abbas',
          'Jahnvi Srivastava',
          'Utkarsh Vijay',
          'Avinash Mittal',
          'Pushpendra Yadav'
        ],
        "team_name": 'DJP Team',
        "project_link": 'https://djp-brickbreakerlegacy.netlify.app/game.html'
      },
      {
        "rank": 6,
        "members": [
          'Shobhit Jain',
          'Nirbhay Aggrwal',
          'Swetanjali Sapra',
          'Kankshit',
          'Anand',
          'Pranay Garg',
          'Gokulnaath'
        ],
        "team_name": 'Local-Ghosts Team',
        "project_link": 'https://local-ghosts.github.io/Brick-Breaker-Final/Game.html'
      }
    ]
  },
  "participation": "You need to divide your team members who are participating into 2 equal sub-teams  which will be participating separately (unless the participating team member count in your team is less than 8).\n\n-think about the design. what all you guys feel like including in this.\n\n-divide the work something like : UI, Audio and visual effects, game design , physics mechanics , level and score screen etc.",
  "judgement": "The criteria for this hackathon would be how well crafted of an experience is the whole game giving for a person who isn't there just for testing it out but actually here to play it out.\n\nthings which matter are:\n\n-physic mechanics of the platform ball interaction\n-UI/UX\n-project completeness as a whole",
  "milestones": "\nWork out with each other. \nSupport your sub-team. \nHave fun everyone!\nGet. Set. God Speed.",
  "prizes": nil,
  "teams_participated": 41,
  "starting_date": '2021-06-26',
  "ending_date": '2021-06-28',
  "participants": nil
)

Hackathon.create(
  "title": 'WHITEBOARD APP',
  "tagline": 'For this hackathon we are going to create a whiteboard app.',
  "reference": 'https://www.tutorialspoint.com/whiteboard.htm',
  "description": "Theres not a lot to be explained here. We can work for the basic features first like : \n- pen tool and canvas color that can be changed\n- straight line making tool with different colors\n\nThats the base. Above this, everything is optional like : \n- circular shape tool\n- undo feature\n- text tool\n- eraser tool\n- changing width of pen tool\n\nTry to use intuitive icons. Maybe if a description pops up when you hover over a tool's icon would be great. but all this is add on for bonus marks in assessment but only work on these once the base is near completion.\n\nIt is going to be a SINGLE PAGE APP",
  "image": 'https://cdn.discordapp.com/attachments/849976559796224069/879816672620470293/unknown.png',
  "leaderboard": {
    "data": [
      {
        "rank": 1,
        "members": [
          'Ayan Dhara',
          'Grawish Sachdeva',
          'Tanmay Vaish',
          'Dhruv Garg',
          'Azhar',
          'Sarvesh Patil',
          'Anjali Goswami'
        ],
        "team_name": 'Untitled Team',
        "project_link": 'https://untitled-team-101.github.io/Whiteboard/'
      },
      {
        "rank": 2,
        "members": [
          'Pooja Kumari',
          'Rahul Maurya',
          'Aayushi Pandey',
          'Gaurav',
          'Suresh Kumar Kumawat',
          'Anmol',
          'Aaliya'
        ],
        "team_name": 'Focussed Team',
        "project_link": 'https://whiteboard-focussed.netlify.app/'
      },
      {
        "rank": 3,
        "members": [
          'Shubham Lingayat',
          'Sanket Itnal',
          'Sanskar Chaware',
          'Aryan Gupta',
          'Swanand Buva',
          'Kaushik Vrudhula'
        ],
        "team_name": 'KND Team',
        "project_link": 'https://knd-devsnest.github.io/slateboard/'
      },
      {
        "rank": 4,
        "members": [
          'Manas Singh',
          'Ayush Mishra',
          'Sahil Verma',
          'Narendra Singh',
          'Ankit Ojha',
          'Gajendra Sharma',
          'Anjali Chauhan'
        ],
        "team_name": 'Stack Team',
        "project_link": 'https://team-stack.netlify.app/'
      },
      {
        "rank": 5,
        "members": [
          'Audarya',
          'Kishore',
          'Sumit Kumar',
          'Alka Das',
          'Harshita',
          'Abhishek Singh'
        ],
        "team_name": 'Sitar Team',
        "project_link": 'https://white-board-sitar.netlify.app/'
      }
    ]
  },
  "participation": "You need to divide your team members who are participating into 2 equal sub-teams  which will be participating separately (unless the participating team member count in your team is less than 8).\n\n\nThink about the design. \n\nwhat all you guys feel like including in this. \n\nDivide the work amongst your teammates uniformly.",
  "judgement": "-Intuitiveness\n\n-UI/UX\n\n-Project completeness as a whole",
  "milestones": "\nWork out with each other. \nSupport your sub-team. \nHave fun everyone!\nGet. Set. God Speed.",
  "prizes": nil,
  "teams_participated": 46,
  "starting_date": '2021-07-03',
  "ending_date": '2021-07-05',
  "participants": nil
)

Hackathon.create(
  "title": ' Indian Tourism Website',
  "tagline": 'For this hackathon we are going to create a landing page for India Tourism web portal',
  "reference": ' https://www.incredibleindia.org/content/incredible-india-v2/en.html',
  "description": "What we need is a landing page which shows what all great places we have in India where people can visit and other details, history and stuff about these places. We also need a simple working form which collects person a visitor's name, email, phone number and query message.\n\n\nPut at least 15 or more places, a form to collect data.\n\n\nIn this hackathon, UI is everything so put all your emphasis on UI UX.",
  "image": 'https://media.discordapp.net/attachments/849976559796224069/879821861154881576/unknown.png',
  "leaderboard": {
    "data": [
      {
        "rank": 1,
        "members": [
          ' Utkarsh Vijay',
          ' Pushpendra Yadav',
          'Prtyush Kumar',
          'Raman Kumar',
          'Chandragupt gosavi',
          'Jahnavi Shrivastav ',
          'Abhisek SAingh'
        ],
        "team_name": 'DJP Team',
        "project_link": 'https://djp-tourism.web.app/'
      },
      {
        "rank": 2,
        "members": [
          'Ayush Mishra',
          'Nikhil Singh',
          'Narendra Singh',
          'Ritik Gour',
          'gajendra Sharma'
        ],
        "team_name": 'Stack Team',
        "project_link": 'https://stackindia.netlify.app/'
      },
      {
        "rank": 3,
        "members": [
          'Shubham Lingayat',
          'Sanket Itnal',
          'Sanskar Chaware',
          'Aryan Gupta',
          'Swanand Buva',
          'Kaushik Vrudhula'
        ],
        "team_name": 'KND Team',
        "project_link": 'https://knd-devsnest.github.io/incredible-india/'
      },
      {
        "rank": 4,
        "members": [
          'Tiyasha Das',
          'Priyanshu Patel',
          'Agastya Singh',
          'Karan S Bisht',
          'Akash Jadhav',
          'Priyanshu Pandey'
        ],
        "team_name": 'Eros Team',
        "project_link": 'https://agastya5singh.github.io/Indian_Tourism_Devsnest/'
      },
      {
        "rank": 5,
        "members": [
          'Anand Dhakane',
          ' Mohit Saran',
          'Neel Patel',
          'Shobhit Jain',
          'Nirbhay Aggarwal'
        ],
        "team_name": 'Sitar Team',
        "project_link": 'https://60f57621df12b9057b8c6a3e--sitar-team.netlify.app/'
      }
    ]
  },
  "participation": "You need to divide your team members who are participating into 2 equal sub-teams which will be participating separately (unless the participating team member count in your team is less than 8).\n\n-think about the design. what all you guys feel like including in this.\n\n-divide the work something like : UI components, data collection for web page/pages, form data collection mechanism etc",
  "judgement": "The criteria for this hackathon would be how well crafted the UI UX is.\n\nthings which matter are:\n\n-well thought off design\n-UI/UX\n-project completeness as a whole",
  "teams_participated": 35,
  "milestones": "\nWork out with each other. \nSupport your sub-team. \nHave fun everyone!\nGet. Set. God Speed.",
  "prizes": nil,
  "starting_date": '2021-07-17',
  "ending_date": '2021-07-19',
  "participants": nil
)

Hackathon.create(
  "title": 'Sudoku Web App',
  "tagline": 'For this hackathon we are going to create a Sudoku Web App',
  "reference": ' https://sudoku.com/',
  "description": "What we need is a Web App on which a user can play sudoku game. You can use a dump of 20 games in the code from which randomly a game will appear. The game should signal in some way if the move made is correct or not ( see reference link. the current element turns blue /red when the move is correct / incorrect).\n\n\nUser should be able to \n- change the game if he/she wants.\n- intuitive UI UX\n",
  "image": 'https://store-images.s-microsoft.com/image/apps.27708.13958030559972232.f735216a-3888-4f06-9fcc-59fe4c08bec3.5383c257-0524-4016-83b0-316b70a3f73b',
  "leaderboard": {
    "data": [
      {
        "rank": 1,
        "members": [
          'Ayan Dhara',
          'Grawish Sachdeva',
          'Tanmay Vaish',
          'Dhruv Garg',
          'Devarshi Patel',
          'Sarvesh Patil',
          'Anjali Goswami'
        ],
        "team_name": 'Untitled Team',
        "project_link": 'https://untitled-team-101.github.io/sudoku/build'
      },
      {
        "rank": 2,
        "members": [
          'Rohit Jaiswal',
          'Moiyyad Sufi',
          'Ravi Kamble',
          'Aditya Agarwal'
        ],
        "team_name": 'Alpha-geeks-team Team',
        "project_link": 'https://king-rohit777.github.io/BETTER-SUDOKU/'
      },
      {
        "rank": 3,
        "members": [
          'Vinitpal Singh',
          'Siddharth'
        ],
        "team_name": 'Evolving Team',
        "project_link": 'https://evolving-sudoku.netlify.app/'
      },
      {
        "rank": 4,
        "members": [
          'Arnab Biswas'
        ],
        "team_name": 'Micro-processing-minions Team',
        "project_link": 'https://github.com/Micro-Processing-Minions/sudoku'
      },
      {
        "rank": 5,
        "members": [
          'Vivek Toppo',
          'Mohd Baqer Haider',
          'Ashirbad Behera'
        ],
        "team_name": 'Async Team',
        "project_link": 'https://async-sudoku.netlify.app/'
      }
    ]
  },
  "participation": "You need to divide your team members who are participating into 2 equal sub-teams which will be participating separately (unless the participating team member count in your team is less than 8).\n\n-think about the design. what all you guys feel like including in this.\n\n-divide the work amongst your sub-team uniformly.",
  "judgement": "The criteria for this hackathon would be how fun and intuitive it is to play the game.\n\nThings which matter are:\n\n-well thought-off design.\n-game logic correctness\n-project completeness as a whole",
  "teams_participated": 14,
  "milestones": "\nWork out with each other. \nSupport your sub-team. \nHave fun everyone!\nGet. Set. God Speed.",
  "prizes": nil,
  "starting_date": '2021-07-24',
  "ending_date": '2021-07-26',
  "participants": nil
)

Hackathon.create(
  "title": '2048 GAME',
  "tagline": 'We need classic 2048 game to look FANTASTIC!',
  "reference": 'https://2048game.com/',
  "description": "Use your frontend skills to see what your can do make a simple game look great. Think how to make something so simple look elegant and easy to play.\n\n\nUser should be able to \n- Correct game mechanics\n- Intuitive UI UX\n- Make the game feel \"snappy\".\n",
  "image": 'https://cdn.discordapp.com/attachments/849976559796224069/879825826181431336/unknown.png',
  "leaderboard": {
    "data": [
      {
        "rank": 1,
        "members": [
          'Utkarsh Vijay',
          'Pushpendra Yadav',
          'Avinash Mittal'
        ],
        "team_name": 'DJP Team',
        "project_link": 'https://djp-2048.netlify.app/game.html'
      },
      {
        "rank": 2,
        "members": [
          'Kamal',
          'Aalok',
          'Krishna Raj',
          'Ankit',
          'Naman Oli'
        ],
        "team_name": 'Reapers Team',
        "project_link": 'https://reapers-2048-game.netlify.app/'
      },
      {
        "rank": 3,
        "members": [
          'Bivas Biswas',
          'Narendra',
          'Annu Bharti',
          'Maseera Ahmed',
          'Soumya',
          'Viraj',
          'Yashvi Garg'
        ],
        "team_name": 'Runtime terror Team',
        "project_link": 'https://2048-game-runtime-terror.netlify.app/'
      },
      {
        "rank": 4,
        "members": [
          'Himanshi Lohiya',
          'Nishit Meswania'
        ],
        "team_name": 'Impact Team',
        "project_link": 'https://2048-game-site.netlify.app/'
      },
      {
        "rank": 5,
        "members": [
          'Lakshit Singh',
          'Gaurav',
          'Anmol',
          'Aaliya Haque',
          'Pooja Kumari',
          'Kshitij Dhama'
        ],
        "team_name": 'Focussed Team',
        "project_link": 'https://team-focussed.github.io/2048/'
      }
    ]
  },
  "participation": "You need to divide your team members who are participating into 2 equal sub-teams  which will be participating separately (unless the participating team member count in your team is less than 8).\n\n-think about the design. what all you guys feel like including in this.\n\n-divide the work amongst your sub-team uniformly.",
  "judgement": "The criteria for this hackathon would be how fun, elegant and intuitive. It should to play the game.\n\nthings which matter are:\n\n-well thought-off design.\n-game logic correctness\n-project completeness as a whole\n",
  "teams_participated": 19,
  "milestones": "\nWork out with each other. \nSupport your sub-team. \nHave fun everyone!\nGet. Set. God Speed.",
  "prizes": nil,
  "starting_date": '2021-07-31',
  "ending_date": '2021-08-02',
  "participants": nil
)
