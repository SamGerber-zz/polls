# == Schema Information
#
# Table name: responses
#
#  id        :integer          not null, primary key
#  user_id   :integer          not null
#  choice_id :integer          not null
#

class Response < ActiveRecord::Base

end
