# frozen_string_literal: true

# Component for displaying a set of collections
class CollectionListComponent < ViewComponent::Base
  renders_many :collections, ->(**params) { CollectionCardComponent.new(**params, heading_tag: @heading_tag) }

  def initialize(heading_tag: :h2)
    @heading_tag = heading_tag
  end
end
