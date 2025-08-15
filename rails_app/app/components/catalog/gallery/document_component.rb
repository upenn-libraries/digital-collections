# frozen_string_literal: true

module Catalog
  module Gallery
    # Customizing Blacklight::Gallery::DocumentComponent v6.0.0 to only display gallery index_fields.
    class DocumentComponent < Blacklight::Gallery::DocumentComponent
      def before_render
        # Only displaying fields that have set the gallery flag to true.
        unless metadata
          gallery_fields = presenter.field_presenters.select { |f| f.field_config.gallery }
          set_slot(:metadata, nil, fields: gallery_fields)
        end

        super
      end
    end
  end
end
