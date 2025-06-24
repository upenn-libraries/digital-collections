# frozen_string_literal: true

# Base application helper
module ApplicationHelper
  def thumbnail(document, _options)
    # TODO: This preview link doesn't work yet.
    image_tag(
      "https://apotheca.library.upenn.edu/v1/items/#{document[:id]}/preview?size=300x300"
    )
  end
end
