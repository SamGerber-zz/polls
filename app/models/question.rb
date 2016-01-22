# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  question   :text             not null
#  poll_id    :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class Question < ActiveRecord::Base
  validates :question, presence: true
  validates :poll_id, presence: true

  has_many :choices,
    class_name: "AnswerChoice",
    foreign_key: :question_id,
    primary_key: :id

  belongs_to :poll,
    inverse_of: :questions,
    class_name: "Poll",
    foreign_key: :poll_id,
    primary_key: :id

  has_many :responses,
    through: :choices,
    source: :responses

  # def results
  #   answer_choices = {}
  #
  #   choices.each do |choice|
  #     answer_choices[choice.choice] = choice.responses.count
  #   end
  #
  #   answer_choices
  # end

  # def results
  #   answer_choices = {}
  #
  #   choices.includes(:responses).each do |choice|
  #     answer_choices[choice.choice] = choice.responses.length
  #   end
  #
  #   answer_choices
  # end

  def results

    response_counts = AnswerChoice.find_by_sql(<<-SQL)
      SELECT
        answer_choices.choice, COUNT(responses.*) AS number_of_responses
      FROM
        answer_choices
      LEFT OUTER JOIN
        responses ON answer_choices.id = responses.choice_id
      WHERE
        answer_choices.question_id = 1
      GROUP BY
        answer_choices.choice
    SQL

    response_counts.each.with_object({}) do |response, results|
      results[response.choice] = response.number_of_responses
    end
  end

end
