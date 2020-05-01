# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

users = [
  {
    email: 'a@a.com',
    password: '123123',
    password_confirmation: '123123',
  },
  {
    email: 'b@b.com',
    password: '123123',
    password_confirmation: '123123',
  },
  {
    email: 'c@c.com',
    password: '123123',
    password_confirmation: '123123',
  }
]

users.each {|u| User.create(u)}

questions = [
  {
    user_id: 1,
    start_time: 1.day.from_now,
    voting_round_end_time: 1.day.from_now,
    question_text: 'Why is the sky blue?'
  },
  {
    user_id: 1,
    start_time: 2.days.from_now,
    voting_round_end_time: 2.days.from_now,
    question_text: 'What is the meaning of life?'
  },
  {
    user_id: 1,
    start_time: 3.days.ago,
    voting_round_end_time: 3.days.ago,
    end_time: 2.days.ago,
    question_text: 'Is there other life on the universe?',
    answer: 'There probably is.'
  },
  {
    user_id: 1,
    start_time: 3.days.ago,
    voting_round_end_time: 3.days.ago,
    end_time: 2.days.ago,
    question_text: 'If we ever meet aliens, what will be the first thing they say to us?',
    answer: 'Stop destroying your planet and yourselves.'
  }
]


questions.each { |q|
  qu = Question.create(q)
  qu.update_start_voting_background_job
}
