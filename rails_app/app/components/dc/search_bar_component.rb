# frozen_string_literal: true

# copied from Blacklight 9

module DC
  # Override Search Bar Component
  class SearchBarComponent < Blacklight::SearchBarComponent
    def initialize(**)
      super

      @classes = %w[dc-search-box]
    end
  end
end
