class Answer < ActiveRecord::Base
  validates :user_id, :question_id, :body, presence: true

  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  default_scope -> { order(best: :desc).order(created_at: :asc) }

  def set_best
    ActiveRecord::Base.transaction do
      self.question.answers.update_all(best: false)
      raise ActiveRecord::Rollback unless self.update(best: true)
    end
  end
end
