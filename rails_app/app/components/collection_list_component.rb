# frozen_string_literal: true

# Component for displaying a set of collections
class CollectionListComponent < ViewComponent::Base
  renders_many :collections, ->(**params) { CollectionCardComponent.new(**params, header_tag: @header_tag) }

  def initialize(header_tag: :h2)
    @header_tag = header_tag
  end
end
