# frozen_string_literal: true

# Base application helper
module ApplicationHelper
  def thumbnail(document, _options)
    thumbnail_uuid = document[:thumbnail_asset_id_ssi]
    return nil unless thumbnail_uuid

    image_tag(
      "https://iiif-images.library.upenn.edu/iiif/2/#{thumbnail_uuid}%2Faccess/full/!300,300/0/default.jpg"
    )
  end
end
