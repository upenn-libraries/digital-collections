# frozen_string_literal: true

# Override Component from Blacklight 9.0.0.beta1 to remove "visually-hidden" on constraints headers,
# some additional styling
module DC
  # Override constraints
  class ConstraintsComponent < Blacklight::ConstraintsComponent
  end
end
