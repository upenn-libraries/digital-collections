# frozen_string_literal: true

module Catalog
  # Override component from Blacklight 9.0.0.beta7 to apply class and render custom search button
  class SearchBarComponent < Blacklight::SearchBarComponent
    def initialize(**)
      super

      @classes = %w[dc-search-box]
    end

    def before_render
      set_slot(:search_button) { render custom_search_button } unless search_button
    end

    private

    # @return [Catalog::SearchButtonComponent]
    def custom_search_button
      Catalog::SearchButtonComponent.new(id: "#{@prefix}search", text: t('search.button.label'))
    end
  end
end
