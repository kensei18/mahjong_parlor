class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: :follower_id,
                                  dependent: :destroy

  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: :followed_id,
                                   dependent: :destroy

  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :reviews,  dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :favorites, dependent: :destroy
  has_many :favorite_parlors, through: :favorites, source: :parlor

  has_many :likes, dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :like_reviews, through: :likes, source: :review

  validates :username, presence: true, uniqueness: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :email, format: { with: VALID_EMAIL_REGEX }

  scope :reviews_count_order, -> do
    left_joins(:reviews).select('users.*, COUNT(reviews.id) AS reviews_count').
      group(:id).order('reviews_count DESC')
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def add_to_favorites(parlor)
    favorite_parlors << parlor
  end

  def remove_from_favorites(parlor)
    favorites.find_by(parlor_id: parlor.id).destroy
  end

  def favorite?(parlor)
    favorite_parlors.include?(parlor)
  end

  def like(review)
    like_reviews << review
  end

  def unlike(review)
    likes.find_by(review_id: review.id).destroy
  end

  def like?(review)
    like_reviews.include?(review)
  end
end
