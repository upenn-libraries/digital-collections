# frozen_string_literal: true

# Helper methods for views rendered by CatalogController
module CatalogHelper
  include Blacklight::CatalogHelperBehavior

  def thumbnail(document, _options)
    return nil unless document.preview?

    image_tag(document.thumbnail_url)
  end

  def fallback_thumbnail(_document, _options)
    content_tag 'pennlibs-fallback-img'
  end
end
