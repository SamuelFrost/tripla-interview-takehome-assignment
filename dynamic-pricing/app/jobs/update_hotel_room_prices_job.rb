class UpdateHotelRoomPricesJob < ApplicationJob
  queue_as :default
  # retry immediately on rateapi error, timeout errors and connection failed errors
  retry_on RateApi::RateApiError, Faraday::TimeoutError, Faraday::ConnectionFailed, wait: 1, attempts: 6

  def perform
    HotelRoomPrice.update_prices
  end
end
