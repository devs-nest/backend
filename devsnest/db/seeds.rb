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

Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each do |seed|
  load seed
end
