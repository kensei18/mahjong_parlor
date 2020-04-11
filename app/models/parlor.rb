class Parlor < ApplicationRecord
  has_many :review

  enum smoking: {
    no_smoking: 0,
    smoking_allowed: 1,
    separation_of_smoking_areas: 2,
  }

  validates :name,      presence: true, uniqueness: { scope: :address }
  validates :address,   presence: true
  validates :latitude,  presence: true
  validates :longitude, presence: true
end
