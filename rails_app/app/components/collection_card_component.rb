# frozen_string_literal: true

# Component for displaying one collection.
class CollectionCardComponent < ViewComponent::Base
  attr_reader :name, :representative_item, :heading_tag

  def initialize(name:, representative_item: nil, heading_tag: :h2)
    @name = name
    @representative_item = representative_item
    @heading_tag = heading_tag
  end

  def collection_facet_url
    search_catalog_path(f: { collection_ssim: [name] })
  end

  def representative_item?
    representative_item&.present?
  end

  def preview_image_url
    return unless representative_item?

    host = Settings.digital_repository.url
    path = "#{Settings.digital_repository.api.resource.items.path}/#{representative_item}/preview"
    query = 'size=350,350'

    URI::HTTPS.build(host: host, path: path, query: query).to_s
  end
end
