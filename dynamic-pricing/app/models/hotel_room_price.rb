class HotelRoomPrice < ApplicationRecord
  validates :period, presence: true
  validates :hotel, presence: true
  validates :room, presence: true
  validates :period, uniqueness: { scope: [:room, :hotel] }

  # update prices from RateApi
  def self.update_prices
    # TODO: use a realistic way to obtain hotels, rooms and periods from a database or API (remove logic relying on hardcoded values)
    attributes =
      RateApi::VALID_PERIODS.flat_map do |period|
        RateApi::VALID_HOTELS.flat_map do |hotel|
          RateApi::VALID_ROOMS.flat_map do |room|
            [{ period:, hotel:, room: }]
          end
        end
      end

    attributes_with_rates = RateApi.new.get_pricing(attributes:)
    HotelRoomPrice.insert_all(attributes_with_rates)
  end

end
