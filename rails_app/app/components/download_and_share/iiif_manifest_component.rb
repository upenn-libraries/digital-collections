# frozen_string_literal: true

module DownloadAndShare
  # Renders IIIF manifest link.
  class IIIFManifestComponent < ViewComponent::Base
    def initialize(document:)
      @document = document
    end

    def render?
      @document.manifest?
    end
  end
end
