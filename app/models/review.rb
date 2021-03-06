class Review < ApplicationRecord
  belongs_to :user
  belongs_to :parlor

  has_many :comments, dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :like_users, through: :likes, source: :user

  has_many_attached :images

  scope :new_order, -> { order(created_at: :desc) }

  validates :title,       presence: true, length: { maximum: 30 }
  validates :content,     presence: true
  validates :overall,     presence: true
  validates :cleanliness, presence: true
  validates :service,     presence: true
  validates :customer,    presence: true

  class << self
    def rating_attributes
      [:overall, :cleanliness, :service, :customer]
    end
  end

  def blank_stars(rating_hash)
    5 - send(rating_hash)
  end

  def shorten_content
    if content.length > 40
      content[0..39] + "..."
    else
      content
    end
  end

  def like_user?(user)
    like_users.include?(user)
  end
end
