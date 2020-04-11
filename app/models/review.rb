class Review < ApplicationRecord
  belongs_to :user
  belongs_to :parlor

  enum smoking: {
    no_smoking: 0,
    smoking_allowed: 1,
    separation_of_smoking_areas: 2,
  }

  validates :title,       presence: true, length: { maximum: 30 }
  validates :content,     presence: true
  validates :smoking,     presence: true
  validates :cleanliness, presence: true
  validates :service,     presence: true
  validates :customer,    presence: true
end
