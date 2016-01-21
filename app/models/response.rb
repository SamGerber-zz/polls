# == Schema Information
#
# Table name: responses
#
#  id        :integer          not null, primary key
#  user_id   :integer          not null
#  choice_id :integer          not null
#

class Response < ActiveRecord::Base
  validates :user_id, presence: true
  validates :choice_id, presence: true

  belongs_to :choice,
    class_name: "AnswerChoice",
    foreign_key: :choice_id,
    primary_key: :id

  belongs_to :respondent,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id

  has_one :question_scope,
    through: :choice,
    source: :question

end
