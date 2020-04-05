class Parlor < ApplicationRecord
  validates :name,      presence: true, uniqueness: { scope: :address }
  validates :address,   presence: true
  validates :latitude,  presence: true
  validates :longitude, presence: true
end
