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
  # @param id [String] item uuid
  # @param assets [Boolean] flag to include assets
  # @return [Hash]
  def item(id, assets: false)
    connection.get("/v1/items/#{id}", { assets: assets })
              .body['data']
  end

  # Return Item JSON using ark id lookup
  #
  # @param ark [Object] ark id
  # @param assets [Boolean] flag to include assets
  # @return [Hash]
  def item_by_ark(ark, assets: false)
    connection.get("/v1/items/lookup/#{ark}", { assets: assets }).body['data']
  end
end
