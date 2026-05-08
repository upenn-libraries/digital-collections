# frozen_string_literal: true

module DownloadAndShare
  # Renders link to download individual files.
  #
  # IMPORTANT: This component is only meant to be used for items that have files that aren't included
  #            in the IIIF Manifest. In the future the use of this component can be expanded.
  class FileDownloadComponent < ViewComponent::Base
    def initialize(document:)
      @document = document
    end

    def assets
      @assets ||= @document.non_iiif_assets.map { |a| AssetPresenter.new(asset: a) }
    end

    def render?
      assets.present?
    end
  end
end
