# frozen_string_literal: true

module Catalog
  # Custom Component to render each value in a multivalued field in a single dd
  class MetadataFieldLayoutComponent < ViewComponent::Base
    renders_one :label
    renders_many(:values, ->(**kwargs, &block) { content_tag(:dd, **kwargs, &block) })

    # @return [TrueClass, FalseClass]
    def render?
      values?
    end
  end
end
