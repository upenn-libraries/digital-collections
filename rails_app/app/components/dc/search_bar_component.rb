# frozen_string_literal: true

# copied from Blacklight 9

module DC
  # Override Search Bar Component
  class SearchBarComponent < Blacklight::SearchBarComponent
    def initialize(**)
      super
      # the search bar classes cannot be customized, so we must override the instance variable
      # to remove the default blacklight/bootstrap styles
      @classes = %w[]
    end
  end
end
