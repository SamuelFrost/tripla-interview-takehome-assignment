FactoryBot.define do
  factory :hotel_room_price do
    period { RateApi::VALID_PERIODS.sample }
    hotel { RateApi::VALID_HOTELS.sample }
    room { RateApi::VALID_ROOMS.sample }
    rate { Faker::Number.between(from: 2000, to: 2000000).to_s }

  end
end
