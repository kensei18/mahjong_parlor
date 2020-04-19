class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :parlor

  validates :user_id,   presence: true, uniqueness: { scope: :parlor_id }
  validates :parlor_id, presence: true
end
