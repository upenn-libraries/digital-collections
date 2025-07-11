# frozen_string_literal: true

# Helper methods for views rendered by CatalogController

# Override BL 9.0.0beat1@de5ddb
module CatalogHelper
  include Blacklight::CatalogHelperBehavior

  def thumbnail(document, _options)
    return nil unless document.preview?

    image_tag("#{Settings.digital_repository.url}/v1/items/#{document[:id]}/preview?size=300,300")
  end

  def fallback_thumbnail(_document, _options)
    content_tag 'pennlibs-fallback-img'
  end
end
