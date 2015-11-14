class Answer < ActiveRecord::Base
  validates :user_id, :question_id, :body, presence: true

  belongs_to :question
  belongs_to :user
end
