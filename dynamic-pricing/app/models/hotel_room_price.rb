class HotelRoomPrice < ApplicationRecord
  validates :period, presence: true
  validates :hotel, presence: true
  validates :room, presence: true
  validates :period, uniqueness: { scope: [:room, :hotel] }

  #TODO add update logic calling RateApi.new.get_pricing(attributes:)
end
