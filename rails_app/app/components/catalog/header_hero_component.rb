# frozen_string_literal: true

module Catalog
  # Custom hero component that renders a header, a picture, and a heading.
  # Used by the base Blacklight layout to render the hero on static pages.
  class HeaderHeroComponent < Blacklight::Component
    attr_accessor :blacklight_config

    renders_one :header, lambda {
      HeaderComponent.new(blacklight_config: blacklight_config, theme: :dark)
    }
    renders_one :picture
    renders_one :heading
    renders_one :subheading

    # @param blacklight_config [Blacklight::Configuration]
    def initialize(blacklight_config:)
      @blacklight_config = blacklight_config
    end

    def before_render
      set_slot(:header, nil) unless header
      set_slot(:picture, nil) unless picture
      set_slot(:heading, nil) unless heading
      set_slot(:subheading, nil) unless subheading
    end
  end
end
