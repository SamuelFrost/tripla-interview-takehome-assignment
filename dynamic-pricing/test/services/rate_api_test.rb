require "test_helper"

class RateApiTest < ActiveSupport::TestCase

  test "returns rate for a single attribute combination" do
    VCR.use_cassette("rate_api/get_pricing_success") do
      response = RateApi.new.get_pricing(attributes: [{ period: "Summer", hotel: "FloatingPointResort", room: "SingletonRoom" }])
      assert_equal response, [{ "hotel" => "FloatingPointResort", "period" => "Summer", "rate" => 19100, "room" => "SingletonRoom" }]
    end
  end

  test "returns rates for multiple attribute combinations" do    
    attributes = [
      { period: "Summer", hotel: "FloatingPointResort", room: "SingletonRoom" },
      { period: "Spring", hotel: "FloatingPointResort", room: "SingletonRoom" },
    ]
    response_attributes = [
      { "hotel" => "FloatingPointResort", "period" => "Summer", "rate" => 37900, "room" => "SingletonRoom" },
      { "hotel" => "FloatingPointResort", "period" => "Spring", "rate" => 61100, "room" => "SingletonRoom" },
    ]

    VCR.use_cassette("rate_api/get_pricing_multiple_attributes_success") do
      response = RateApi.new.get_pricing(attributes:)
      # ensure the rates are returned for each attribute combination
      assert_equal response, response_attributes
    end
  end

  test "should raise error if pricing is not found" do
    VCR.use_cassette("rate_api/get_pricing_not_found") do
      assert_raises "Failed to get pricing" do
        RateApi.new.get_pricing(attributes: [{ period: "Summer", hotel: "FloatingPointResort", room: "NonexistentRoom" }])
      end
    end
  end

  test "should raise error if attributes are invalid" do
    VCR.use_cassette("rate_api/get_pricing_invalid_attributes") do
      assert_raises "Failed to get pricing" do
        RateApi.new.get_pricing(attributes: [{ period: "Summer", hotel: "FloatingPointResort" }])
      end
    end
  end
end
