class Parlor < ApplicationRecord
  has_many :reviews

  enum smoking: {
    unknown: 0,
    no_smoking: 1,
    smoking_allowed: 2,
    separation_of_smoking_areas: 3,
  }

  before_validation :format_address

  validates :name,      presence: true, uniqueness: { scope: :address }
  validates :address,   presence: true
  validates :latitude,  presence: true
  validates :longitude, presence: true

  private

  def format_address
    japan = "日本、"
    address.delete! japan if address.start_with?(japan)
  end
end
