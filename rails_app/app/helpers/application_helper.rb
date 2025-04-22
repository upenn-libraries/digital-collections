# frozen_string_literal: true

# Base application helper
module ApplicationHelper
  def thumbnail(document, _options)
    image_tag(
      "https://iiif-images.library.upenn.edu/iiif/2/#{document[:thumbnail_asset_id_ssi]}
%2Faccess/full/!200,200/0/default.jpg"
    )
  end
end
