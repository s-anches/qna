class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  accepts_nested_attributes_for :attachments,
          reject_if: proc{ |param| param[:file].blank? },
          allow_destroy: true
  accepts_nested_attributes_for :votes

  validates :user_id, :title, :body, presence: true
end
