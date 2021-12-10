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

# Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each do |seed|
#   load seed
# end

Minibootcamp.create(unique_id:"bootcamp", content_type: 0)
Minibootcamp.create(unique_id:"HTML", parent_id: 'bootcamp', content_type: 1)
Minibootcamp.create(unique_id:"html-mod-1", parent_id: 'HTML', content_type: 2, markdown: 'hello')
Minibootcamp.create(unique_id:"html-mod-2", parent_id: 'HTML', content_type: 2, markdown: 'hello')
Minibootcamp.create(unique_id:"html-mod-3", parent_id: 'HTML', content_type: 2, markdown: 'world')
Minibootcamp.create(unique_id:"html-mod-4", parent_id: 'HTML', content_type: 2, markdown: 'lakshit')
Minibootcamp.create(unique_id:"html-mod-5", parent_id: 'HTML', content_type: 2, markdown: 'kaydee')
Minibootcamp.create(unique_id:"CSS", parent_id: 'bootcamp', content_type: 1)
Minibootcamp.create(unique_id:"css-mod-1", parent_id: 'CSS', content_type: 2, markdown: 'getthereveryfastindeed')
Minibootcamp.create(unique_id:"css-mod-2", parent_id: 'CSS', content_type: 2, markdown: 'HELLO CSS')
Minibootcamp.create(unique_id:"css-mod-3", parent_id: 'CSS', content_type: 2, markdown: 'world')
Minibootcamp.create(unique_id:"css-mod-4", parent_id: 'CSS', content_type: 2, markdown: 'MODULE 4')
Minibootcamp.create(unique_id:"css-mod-5", parent_id: 'CSS', content_type: 2, markdown: 'MODULE 5')
Minibootcamp.create(unique_id:"Javascript", parent_id: 'bootcamp', content_type: 1)
Minibootcamp.create(unique_id:"js-mod-1", parent_id: 'Javascript', content_type: 2, markdown: 'hello')
Minibootcamp.create(unique_id:"js-mod-2", parent_id: 'Javascript', content_type: 2, markdown: 'WORLD')
Minibootcamp.create(unique_id:"js-mod-2", parent_id: 'Javascript', content_type: 2, markdown: 'HELLO JS')
Minibootcamp.create(unique_id:"js-mod-3", parent_id: 'Javascript', content_type: 2, markdown: 'MODULE 3')
Minibootcamp.create(unique_id:"js-mod-4", parent_id: 'Javascript', content_type: 2, markdown: 'MODULE 4')
