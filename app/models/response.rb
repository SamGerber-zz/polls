# == Schema Information
#
# Table name: responses
#
#  id        :integer          not null, primary key
#  user_id   :integer          not null
#  choice_id :integer          not null
#

class Response < ActiveRecord::Base
  validates :user_id, presence: true, uniqueness: {scope: :choice_id}
  validates :choice_id, presence: true
  validate :not_duplicate_response

  belongs_to :choice,
    class_name: "AnswerChoice",
    foreign_key: :choice_id,
    primary_key: :id

  belongs_to :respondent,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id

  has_one :question,
    through: :choice,
    source: :question

  def sibling_responses
    self.question.responses.where.not(id: self.id)
  end

  def respondent_already_answered?
    sibling_responses.exists?(user_id: user_id)
  end

  private

  def not_duplicate_response
    !respondent_already_answered?
  end
  
end
