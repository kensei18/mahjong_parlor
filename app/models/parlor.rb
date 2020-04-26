class Parlor < ApplicationRecord
  has_many :reviews, dependent: :destroy

  has_many :favorites, dependent: :destroy
  has_many :favored_users, through: :favorites, source: :user

  enum smoking: {
    unknown: 0,
    no_smoking: 1,
    smoking_allowed: 2,
    separation_of_smoking_areas: 3,
  }

  before_validation :format_address

  before_save :downcase_website

  validates :name,      presence: true, uniqueness: { scope: :address }
  validates :address,   presence: true
  validates :latitude,  presence: true
  validates :longitude, presence: true

  VALID_URL_REGEX = /https?:\/\/[\w\/:%#\$&\?\(\)~\.=\+\-]+/i.freeze
  validates :website, format: { with: VALID_URL_REGEX }, allow_blank: true

  class << self
    def search(keywords, max_num: count)
      if keywords.present?
        patterns = ""
        keywords_array = []

        keywords.split.each do |keyword|
          patterns += " AND " if patterns.present?
          patterns += "(name LIKE ? OR address LIKE ?)"
          2.times { keywords_array << "%#{keyword}%" }
        end

        if max_num >= 1
          where(patterns, *keywords_array).limit(max_num)
        else
          where(patterns, *keywords_array)
        end
      end
    end
  end

  def rating(hash: :overall)
    if reviews.present?
      reviews.pluck(hash).sum.fdiv(reviews.size).round(1)
    else
      0.0
    end
  end

  def display_images(count: nil)
    images = reviews.with_attached_images.map { |review| review.images }.flatten
    if count
      images.take(count)
    else
      images
    end
  end

  private

  def format_address
    japan = "日本、"
    address.delete! japan if address.start_with?(japan)
  end

  def downcase_website
    website.downcase! if website.present?
  end
end
