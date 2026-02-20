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

  test "job retries on rate api error then succeeds on second attempt" do
    VCR.use_cassette("rate_api/get_pricing_all_attributes_retry_then_success") do
      assert_difference "HotelRoomPrice.count", TOTAL_SEASONAL_HOTEL_ROOM_COUNT do
        perform_enqueued_jobs only: UpdateHotelRoomPricesJob do
          UpdateHotelRoomPricesJob.perform_later
        end
      end
      assert_performed_jobs 2, only: UpdateHotelRoomPricesJob
      assert_equal performed_jobs.last["exception_executions"],  {"[RateApi::RateApiError, Faraday::TimeoutError, Faraday::ConnectionFailed]"=>1}
    end
  end

  test "job does not retry indefinitely on rate api error" do
    VCR.use_cassette("rate_api/get_pricing_all_attributes_500_error", allow_playback_repeats: true) do
      begin
        perform_enqueued_jobs only: UpdateHotelRoomPricesJob do
          UpdateHotelRoomPricesJob.perform_later
        end
      rescue Minitest::UnexpectedError => test_failure_exception # as we are using a test adapter, minitest raises an UnexpectedError when the job raises an exception, not the job itself
        error = test_failure_exception.error # extract the exception from the UnexpectedError
      end
      assert_instance_of RateApi::RateApiError, error, "Expected job to raise RateApi::RateApiError after exhausting retries"
      assert_equal "Failed to get pricing, response status: 500", error.message, "Expected job to raise RateApi::RateApiError after exhausting retries"
      assert_performed_jobs 3, only: UpdateHotelRoomPricesJob
      assert_equal performed_jobs.last["exception_executions"],  {"[RateApi::RateApiError, Faraday::TimeoutError, Faraday::ConnectionFailed]"=>3}
    end
  end
end