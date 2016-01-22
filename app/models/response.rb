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
  validate :not_respond_to_own_poll

  belongs_to :choice,
    inverse_of: :responses,
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

  has_one :poll,
    through: :question,
    source: :poll


  def sibling_responses
    self.question.responses.where.not(id: self.id)
  end

  def respondent_already_answered?
    sibling_responses.exists?(user_id: user_id)
  end

  def poll_author
    self.question.poll.author
    # self.poll.author #=> nil
  end

  def user_is_poll_author?
    poll_author.id == self.user_id
  end

  def not_duplicate_response
    if respondent_already_answered?
      errors[:base] << "can't answer poll multiple times"
    end
  end

  def not_respond_to_own_poll
    if user_is_poll_author?
      errors[:base] << "can't respond to own poll"
    end
  end

end
