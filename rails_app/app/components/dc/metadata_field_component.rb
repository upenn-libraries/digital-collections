# frozen_string_literal: true

module DC
  # Copied from Blacklight 9.0.0beta1@de55db to render each element in a multivalued field with a single dd
  class MetadataFieldComponent < Blacklight::MetadataFieldComponent
    def initialize(field:, layout: nil, show: nil, view_type: nil)
      super
      @layout = DC::MetadataFieldLayoutComponent
    end

    # @return [Array]
    def render_field
      operations = Blacklight::Rendering::Pipeline.operations - [Blacklight::Rendering::Join]
      Blacklight::Rendering::Pipeline.new(@field.values, @field.field_config, @field.document, @field.view_context,
                                          operations, @field.options).render
    end
  end
end
