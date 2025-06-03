# frozen_string_literal: true

module Gallery
  # Customizing Blacklight::MetadataFieldLayoutComponent v9.0.0beta1 to remove labels from
  # metadata fields in gallery view.
  class MetadataFieldLayoutComponent < Blacklight::MetadataFieldLayoutComponent
    def initialize(field:, **)
      super
      @value_tag = 'span'
    end
  end
end
