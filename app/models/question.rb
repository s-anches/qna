class Question < ActiveRecord::Base
  validates :title, :body, presence: true

  belongs_to :user
  has_many :answers, dependent: :destroy
end
