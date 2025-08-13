# frozen_string_literal: true

module DC
  # Copied from Blacklight 9.0.0beta1@de55db to render our custom MetadataFieldLayoutComponent
  class MetadataFieldComponent < Blacklight::MetadataFieldComponent
    def initialize(field:, layout: nil, show: nil, view_type: nil)
      super
      @layout = DC::MetadataFieldLayoutComponent
    end
  end
end
