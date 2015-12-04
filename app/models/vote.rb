class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :user_id, presence: true

  scope :likes, -> { where("value > 0") }
  scope :dislikes, -> { where("value < 0") }
end
