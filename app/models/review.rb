class Review < ApplicationRecord
  belongs_to :user
  belongs_to :parlor

  validates :title,       presence: true, length: { maximum: 30 }
  validates :content,     presence: true
  validates :cleanliness, presence: true
  validates :service,     presence: true
  validates :customer,    presence: true
end
