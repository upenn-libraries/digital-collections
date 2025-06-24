# frozen_string_literal: true

# Class to connect to the digital repository and extract content.
class DigitalRepository
  attr_reader :url

  def initialize(url: nil)
    @url = url || Settings.digital_repository.url
  end

  # Faraday connection to the digital repository public API.
  #
  # @return [Faraday::Connection]
  def connection
    @connection ||= Faraday.new(url: url) do |config|
      config.request :json # Sets the Content-Type header to application/json on each request.
      config.response :raise_error # Raises an error on 4xx and 5xx responses.
      config.response :json # Parses JSON response bodies.
    end
  end

  # Return Item JSON.
  #
  # @return [Hash]
  def item(id, assets: false)
    connection.get("/v1/items/#{id}", { assets: assets })
              .body['data']
  end
end
