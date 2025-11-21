# frozen_string_literal: true

# Render find-this-item call to action
class FindThisItemComponent < ViewComponent::Base
  # @param document [SolrDocument]
  def initialize(document:)
    @document = document
  end

  # @return [Boolean]
  def render?
    @document.digital_catalog_url || location?
  end

  private

  # @return [Boolean]
  def location?
    location.present?
  end

  # @return [Array]
  def location
    @document.fetch('physical_location_tesim', [])
  end
end
