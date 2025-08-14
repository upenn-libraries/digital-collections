# frozen_string_literal: true

module DownloadAndShare
  # Renders PDF and IIIF manifest links
  class ItemDerivativesAccordionComponent < ViewComponent::Base
    def initialize(document:)
      @document = document
    end

    # @return [Boolean]
    def render?
      @document.manifest? || @document.pdf?
    end

    private

    # @return [String, nil]
    def iiif_image_count_text
      count = @document.iiif_image_count
      return unless count.positive?

      locale_scope = 'show.download_and_share.pdf.button'
      count == 1 ? t("#{locale_scope}.single_image") : t("#{locale_scope}.multiple_images", count: count)
    end

    # @return [String, Nil]
    def pdf_size
      bytes = @document.pdf['size_bytes']

      return if bytes.blank?

      number_to_human_size bytes, prefix: :si
    end
  end
end
