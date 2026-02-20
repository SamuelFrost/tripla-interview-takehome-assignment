require "test_helper"

class UpdateHotelRoomPricesJobTest < ActiveJob::TestCase
  # Use test adapter so perform_enqueued_jobs actually runs jobs (perform_now does not retry)
  def queue_adapter_for_test
    ActiveJob::QueueAdapters::TestAdapter.new
  end

  TOTAL_SEASONAL_HOTEL_ROOM_COUNT = RateApi::VALID_PERIODS.count * RateApi::VALID_HOTELS.count * RateApi::VALID_ROOMS.count

  test "job calls HotelRoomPrice.update_prices" do
    VCR.use_cassette("rate_api/get_pricing_all_attributes_success") do
      assert_difference "HotelRoomPrice.count", TOTAL_SEASONAL_HOTEL_ROOM_COUNT do
        UpdateHotelRoomPricesJob.perform_now
      end
    end
  end

  test "job retries on rate api error then succeeds on second attempt" do
    VCR.use_cassette("rate_api/get_pricing_all_attributes_retry_then_success") do
      assert_difference "HotelRoomPrice.count", TOTAL_SEASONAL_HOTEL_ROOM_COUNT do
        perform_enqueued_jobs do
          UpdateHotelRoomPricesJob.perform_later
        end
      end
    end
  end
end