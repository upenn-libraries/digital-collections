# frozen_string_literal: true

# Class to connect to the digital repository and extract content.
class DigitalRepository
  attr_reader :url

  def initialize(url: nil)
    @url = url || URI::HTTPS.build(host: host).to_s
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
    connection.get("#{item_resource_path}/#{id}", { assets: assets })
              .body['data']
  end

  # Return Item JSON using ark id lookup
  #
  # @param ark [String] ark id
  # @param assets [Boolean] flag to include assets
  # @return [Hash]
  def item_by_ark(ark, assets: false)
    connection.get("#{item_resource_path}/lookup/#{ark}", { assets: assets }).body['data']
  end

  # @param id [String]
  # @return [String]
  def item_manifest_url(id)
    path = "#{item_iiif_path}/#{id}/manifest"
    URI::HTTPS.build(host: host, path: path).to_s
  end

  # @param id [String]
  # @return [String]
  def item_pdf_url(id)
    path = "#{item_resource_path}/#{id}/pdf"
    URI::HTTPS.build(host: host, path: path).to_s
  end

  # @param id [String]
  # @param size [String] IIIF image API size param as a string
  # @return [String]
  def item_preview_url(id, size)
    path = "#{item_resource_path}/#{id}/preview"
    URI::HTTPS.build(host: host, path: path, query: size).to_s
  end

  private

  # @return [String]
  def host
    Settings.digital_repository.host
  end

  # @return [String]
  def item_resource_path
    Settings.digital_repository.api.resource.items.path
  end

  # @return [String]
  def item_iiif_path
    Settings.digital_repository.api.iiif.items.path
  end
end
