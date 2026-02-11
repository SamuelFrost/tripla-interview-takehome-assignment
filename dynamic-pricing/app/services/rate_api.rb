class RateApi
  # TODO: use a realistic way to obtain hotels, rooms and periods from a database or API (remove logic relying on hardcoded values)
  VALID_PERIODS = %w[Summer Autumn Winter Spring].freeze
  VALID_HOTELS = %w[FloatingPointResort GitawayHotel RecursionRetreat].freeze
  VALID_ROOMS = %w[SingletonRoom BooleanTwin RestfulKing].freeze


  def initialize()
    @url = ENV['RATE_API_URL'] || 'http://localhost:8080'
    @key = ENV['RATE_API_KEY'] || '04aa6f42aa03f220c2ae9a276cd68c62'
  end

  # @param attributes [{ period: String, hotel: String, room: String }] Hotel room attributes
  # @return [{ period: String, hotel: String, room: String, rate: Decimal }] Hotel room attributes with their rates
  # @example
  #   RateApi.new.get_pricing(attributes: [{ period: 'Summer', hotel: 'FloatingPointResort', room: 'SingletonRoom' }, { period: 'Autumn', hotel: 'FloatingPointResort', room: 'SingletonRoom' }])
  #   # => [{ period: 'Summer', hotel: 'FloatingPointResort', room: 'SingletonRoom', rate: 100 }, { period: 'Autumn', hotel: 'FloatingPointResort', room: 'SingletonRoom', rate: 100 }]
  def get_pricing(attributes:)

    response = Faraday.post("#{@url}/pricing") do |request|
      # MEMO: removing user-agent as the API behaves strangely (does not return a rate) with this header
      request.headers.delete('user-agent')
      request.headers['Content-Type'] = 'application/json'
      request.headers['token'] = "#{@key}"
      request.body = { attributes: }.to_json
    end

    if response.success?
      JSON.parse(response.body)["rates"]
    else
      raise "Failed to get pricing"
    end
  end
end