class Question < ActiveRecord::Base
  include Votable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy

  accepts_nested_attributes_for :attachments,
          reject_if: proc{ |param| param[:file].blank? },
          allow_destroy: true

  validates :user_id, :title, :body, presence: true
end
