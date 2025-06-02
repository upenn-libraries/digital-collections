# frozen_string_literal: true

module DC
  # Custom hero component that renders a header, a picture, and a heading.
  # Used by the base Blacklight layout to render the hero on static pages.
  class HeroComponent < Blacklight::Component
    attr_accessor :blacklight_config, :user

    renders_one :header, lambda {
      HeaderComponent.new(blacklight_config: blacklight_config, user: user, theme: :dark)
    }
    renders_one :picture
    renders_one :heading
    renders_one :subheading

    # @param blacklight_config [Blacklight::Configuration]
    # @param user [User]
    def initialize(blacklight_config:, user:)
      @blacklight_config = blacklight_config
      @user = user
    end

    def before_render
      set_slot(:header, nil) unless header
      set_slot(:picture, nil) unless picture
      set_slot(:heading, nil) unless heading
      set_slot(:subheading, nil) unless subheading
    end
  end
end
