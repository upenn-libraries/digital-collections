# frozen_string_literal: true

module Catalog
  # Override DocumentComponent from Blacklight 9.0.0.beta8 to render our custom MetadataFieldLayoutComponent.
  class MetadataFieldComponent < Blacklight::MetadataFieldComponent
    def initialize(field:, layout: nil, show: nil, view_type: nil)
      super
      @layout = Catalog::MetadataFieldLayoutComponent
    end
  end
end
