# frozen_string_literal: true

# Customizing Blacklight::Gallery::DocumentComponent to only display gallery index_fields.
class GalleryComponent < Blacklight::Gallery::DocumentComponent
  def before_render
    # Only displaying fields that have set the gallery flag to true.
    unless metadata
      gallery_fields = presenter.field_presenters.select { |f| f.field_config.gallery }
      set_slot(:metadata, nil, fields: gallery_fields, field_layout: Gallery::MetadataFieldLayoutComponent)
    end

    super
  end
end
