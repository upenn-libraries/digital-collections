# frozen_string_literal: true

# Override component from Blacklight 9.0.0.beta7 to adjust heading_classes.
module Catalog
  # Override constraints
  class ConstraintsComponent < Blacklight::ConstraintsComponent
    def initialize(**)
      super

      @heading_classes = nil
    end
  end
end
