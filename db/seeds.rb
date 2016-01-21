# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ActiveRecord::Base.transaction do

  20.times do
    user = User.create!(user_name: Faker::Internet.user_name)
    rand(3).times do
      poll = Poll.create!(title: Faker::Company.catch_phrase, author_id: user.id)
      (1+rand(3)).times do
        question = Question.create!(question: Faker::Hipster.sentence[0...-1].concat("?"), poll_id: poll.id)
        5.times do
          AnswerChoice.create!(choice: Faker::Hacker.say_something_smart, question_id: question.id)
        end
      end
    end
  end

  User.all.each do |user|
    choice = AnswerChoice.all.sample(1)[0]
    Response.create!(user_id: user.id, choice_id: choice.id)
  end

end
