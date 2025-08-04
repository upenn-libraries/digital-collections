# frozen_string_literal: true

module DC
  # Renders list of file downloads for a collection of assets
  class FileDownloadComponent < ViewComponent::Base
    attr_reader :assets

    # @param assets [Array<Hash>]
    def initialize(assets: [])
      @assets = assets
    end

    # @return [TrueClass, FalseClass]
    def render?
      assets.present?
    end

    private

    # @param asset [Hash]
    # @return [TrueClass, FalseClass]
    def access?(asset)
      asset.dig('derivatives', 'access').present?
    end

    # @param asset [Hash]
    # @return [String, nil]
    def access_file_url(asset)
      asset.dig('derivatives', 'access', 'url')
    end

    # @param asset [Hash]
    # @return [String, nil]
    def preservation_file_url(asset)
      asset.dig('preservation_file', 'url')
    end

    # @param asset [Hash]
    # @return [String, nil]
    def human_readable_size(asset)
      bytes = asset.dig('preservation_file', 'size_bytes')
      return unless bytes

      number_to_human_size(bytes, prefix: :si)
    end
  end
end
