# frozen_string_literal: true

module Catalog
  # This is a custom header component that render a search bar.
  # It's used in two places:
  # 1. We set the header to this component in the catalog controller to render on all Blacklight pages.
  # 2. We tell the base Blacklight layout to render the HeaderHeroComponent on static pages,
  #    which has a slot for this component.
  class HeaderComponent < Blacklight::Component
    attr_accessor :blacklight_config, :theme

    renders_one :search_bar, lambda { |component: Catalog::SearchNavbarComponent|
      component.new(blacklight_config: blacklight_config)
    }

    # @param blacklight_config [Blacklight::Configuration]
    def initialize(blacklight_config:, theme: :light)
      @blacklight_config = blacklight_config
      @theme = theme
    end

    def before_render
      set_slot(:search_bar, nil) unless search_bar
    end
  end
end
