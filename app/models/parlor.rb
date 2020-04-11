class Parlor < ApplicationRecord
  has_many :review

  validates :name,      presence: true, uniqueness: { scope: :address }
  validates :address,   presence: true
  validates :latitude,  presence: true
  validates :longitude, presence: true
end
