# frozen_string_literal: true

# copied from Blacklight 9

require_dependency Blacklight::Engine.root.join('app', 'components', 'blacklight', 'search_bar_component').to_s

module DC
  # Override Search Bar Component
  class SearchBarComponent < Blacklight::SearchBarComponent
    def initialize(**)
      super
    end
  end
end
