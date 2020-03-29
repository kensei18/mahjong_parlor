class Parlor < ApplicationRecord
  validates :name, uniqueness: { scope: :address }
end
