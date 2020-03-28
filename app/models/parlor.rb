class Parlor < ApplicationRecord
  validates :address, uniqueness: true
end
