class UpdateHotelRoomPricesJob < ApplicationJob
  queue_as :default

  def perform
    HotelRoomPrice.update_prices
  end
end
