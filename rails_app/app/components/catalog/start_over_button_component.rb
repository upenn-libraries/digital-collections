# frozen_string_literal: true

module Catalog
  # Local component copied from Blacklight v9.0
  class StartOverButtonComponent < Blacklight::Component
    private

    ##
    # Get the path to the search action with any parameters (e.g. view type)
    # that should be persisted across search sessions.
    def start_over_path(_query_params = params)
      helpers.root_path
    end
  end
end
