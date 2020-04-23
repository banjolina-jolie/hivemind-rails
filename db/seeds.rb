# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

users = [{
  email: 'dylancocarroll@gmail.com',
  password: 'richard',
  password_confirmation: 'richard',
}]
users.each {|u| User.create(u)}

questions = [{user_id: 1, question_text: 'why is the sky blue?'}]
questions.each {|q| Question.create(q)}
