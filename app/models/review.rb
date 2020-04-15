class Review < ApplicationRecord
  belongs_to :user
  belongs_to :parlor

  validates :title,       presence: true, length: { maximum: 30 }
  validates :content,     presence: true
  validates :overall,     presence: true
  validates :cleanliness, presence: true
  validates :service,     presence: true
  validates :customer,    presence: true

  def self.rating_attributes
    [:overall, :cleanliness, :service, :customer]
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
end



