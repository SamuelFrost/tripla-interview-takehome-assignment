require "test_helper"

class UpdateHotelRoomPricesJobTest < ActiveJob::TestCase
  TOTAL_SEASONAL_HOTEL_ROOM_COUNT = RateApi::VALID_PERIODS.count * RateApi::VALID_HOTELS.count * RateApi::VALID_ROOMS.count
 
  test "job calls HotelRoomPrice.update_prices" do
    VCR.use_cassette("rate_api/get_pricing_all_attributes_success") do
      assert_difference "HotelRoomPrice.count", TOTAL_SEASONAL_HOTEL_ROOM_COUNT do
        UpdateHotelRoomPricesJob.perform_now
      end
    end
  end
end
