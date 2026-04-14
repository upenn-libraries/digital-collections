# frozen_string_literal: true

module Catalog
  # Override component from Blacklight v9.0.0 to apply class and render custom search button
  class SearchBarComponent < Blacklight::SearchBarComponent
    def initialize(**)
      super

      @classes = %w[dc-search-box]
    end

    # @return [Catalog::SearchButtonComponent]
    def default_search_button
      Catalog::SearchButtonComponent.new(id: "#{@prefix}search", text: t('search.button.label'))
    end
  end
end
