# frozen_string_literal: true

module Catalog
  module Gallery
    # sets desired metadata to display in gallery view
    class DocumentMetadataComponent < Blacklight::DocumentMetadataComponent
      def before_render
        return unless fields

        @fields.select { |field| field.key == :title_tsim }.each do |field|
          with_field(component: field.component, field: field, show: @show, view_type: @view_type,
                     layout: @field_layout)
        end
      end
    end
  end
end
