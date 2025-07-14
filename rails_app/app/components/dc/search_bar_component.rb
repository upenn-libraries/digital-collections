# frozen_string_literal: true

# copied from Blacklight 9

module DC
  # Override Search Bar Component to apply class and render custom search button
  class SearchBarComponent < Blacklight::SearchBarComponent
    def initialize(**)
      super

      @classes = %w[dc-search-box]
    end

    def before_render
      set_slot(:search_button) { render custom_search_button } unless search_button
    end

    private

    # @return [DC::SearchButtonComponent]
    def custom_search_button
      DC::SearchButtonComponent.new(id: "#{@prefix}search", text: t('search.button.label'))
    end
  end
end
