# frozen_string_literal: true

module DC
  # Customizing Blacklight::Gallery::DocumentComponent v6.0 to:
  # - only display gallery index_fields.
  # - add custom class to the metadata component
  class GalleryComponent < Blacklight::Gallery::DocumentComponent
    def before_render
      # Only displaying fields that have set the gallery flag to true.
      unless metadata
        gallery_fields = presenter.field_presenters.select { |f| f.field_config.gallery }
        set_slot(:metadata, nil, fields: gallery_fields,
                                 field_layout: DC::Gallery::MetadataFieldLayoutComponent,
                                 classes: 'pl-dl--inline')
      end

      super
    end
  end
end
