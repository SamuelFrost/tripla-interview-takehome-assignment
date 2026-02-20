require "test_helper"

class HotelRoomPriceTest < ActiveSupport::TestCase
  TOTAL_SEASONAL_HOTEL_ROOM_COUNT=RateApi::VALID_PERIODS.count * RateApi::VALID_HOTELS.count * RateApi::VALID_ROOMS.count

  test "update_prices fetches rates and inserts them" do

    VCR.use_cassette("rate_api/get_pricing_all_attributes_success") do
      HotelRoomPrice.update_prices
      assert_equal TOTAL_SEASONAL_HOTEL_ROOM_COUNT, HotelRoomPrice.count
      # check a single sample of the rates
      assert_equal "51600", HotelRoomPrice.find_by(period: "Summer", hotel: "FloatingPointResort", room: "SingletonRoom").rate
    end
  end

  test "update_prices does not insert duplicate rates and instead overwrites them" do
    VCR.use_cassette("rate_api/get_pricing_all_attributes_success") do
      HotelRoomPrice.update_prices
      assert_equal TOTAL_SEASONAL_HOTEL_ROOM_COUNT, HotelRoomPrice.count
      assert_equal "51600", HotelRoomPrice.find_by(period: "Summer", hotel: "FloatingPointResort", room: "SingletonRoom").rate
    end

    VCR.use_cassette("rate_api/get_pricing_all_attributes_success_with_different_rates") do
      HotelRoomPrice.update_prices
      assert_equal TOTAL_SEASONAL_HOTEL_ROOM_COUNT, HotelRoomPrice.count
      assert_equal "62700", HotelRoomPrice.find_by(period: "Summer", hotel: "FloatingPointResort", room: "SingletonRoom").rate
    end
  end

  test "should not change any hotel room prices if the API returns success but rates are nil" do
    create(:hotel_room_price, period: "Spring", hotel: "FloatingPointResort", room: "BooleanTwin", rate: "51600")
    VCR.use_cassette("rate_api/get_pricing_nil_rates") do
      HotelRoomPrice.update_prices
      assert_equal "51600", HotelRoomPrice.find_by(period: "Spring", hotel: "FloatingPointResort", room: "BooleanTwin").rate
    end
  end
end
