# frozen_string_literal: true

module DownloadAndShare
  # Renders list of file downloads for a collection of assets
  class AssetDownloadListComponent < ViewComponent::Base
    attr_reader :assets

    # @param assets [Array<Hash>]
    def initialize(assets: [])
      @assets = assets.map { |a| AssetPresenter.new(asset: a) }
    end

    # @return [Boolean]
    def render?
      assets.present?
    end
  end
end
