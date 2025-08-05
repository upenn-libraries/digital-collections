# frozen_string_literal: true

class CollectionListComponent < ViewComponent::Base
  renders_many :collections, CollectionCardComponent
end