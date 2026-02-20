require "test_helper"
require "webmock/minitest"

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
      error = assert_raises(RateApi::InvalidRequestError) do
        RateApi.new.get_pricing(attributes: [{ period: "Summer", hotel: "FloatingPointResort" }])
      end
      assert_equal "Invalid request: [{:period=>\"Summer\", :hotel=>\"FloatingPointResort\"}]", error.message
    end
  end

  test "should raise error when API returns 500 status" do
    VCR.use_cassette("rate_api/get_pricing_500_error") do
      error = assert_raises(RateApi::RateApiError) do
        RateApi.new.get_pricing(attributes: [{ period: "Summer", hotel: "RecursionRetreat", room: "BooleanTwin" }])
      end
      assert_equal "Failed to get pricing, response status: 500", error.message
    end
  end

  test "should raise timeout error when API times out" do
    stub_request(:post, "#{ENV['RATE_API_URL'] || 'http://rate-api:8080'}/pricing")
      .to_timeout
    
    error = assert_raises(Faraday::ConnectionFailed) do
      RateApi.new.get_pricing(attributes: [{ period: "Autumn", hotel: "FloatingPointResort", room: "SingletonRoom" }])
    end
    assert_match(/execution expired/, error.message)
  end
end
