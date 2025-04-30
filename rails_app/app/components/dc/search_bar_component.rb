# frozen_string_literal: true

# copied from Blacklight 9

module DC
  # Override Search Bar Component
  class SearchBarComponent < Blacklight::SearchBarComponent
    def initialize(
      url:, params:,
      advanced_search_url: nil,
      classes: %w[], prefix: nil,
      method: 'GET', q: nil, query_param: :q,
      search_field: nil, autocomplete_path: nil,
      autofocus: nil, i18n: { scope: 'blacklight.search.form' },
      form_options: {}
    )
      super
    end
  end
end
