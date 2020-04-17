class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :review

  validates :content, presence: true

  def parlor
    review.parlor
  end
end
