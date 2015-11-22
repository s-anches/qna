class Question < ActiveRecord::Base
  validates :user_id, :title, :body, presence: true

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
end
