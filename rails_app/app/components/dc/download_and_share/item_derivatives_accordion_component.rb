# frozen_string_literal: true

module DC
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

      # @return [String, Nil]
      def pdf_size
        bytes = @document.pdf['size_bytes']

        return if bytes.blank?

        number_to_human_size bytes, prefix: :si
      end
    end
  end
end
