# frozen_string_literal: true

# copied from Blacklight 9

module DC
  # Override Header Component
  class HeaderComponent < Blacklight::Component
    attr_reader :blacklight_config, :user

    renders_one :search_bar, lambda { |component: DC::SearchNavbarComponent|
      component.new(blacklight_config: blacklight_config)
    }

    # @param blacklight_config [Blacklight::Configuration]
    # @param user [User]
    def initialize(blacklight_config:, user:)
      @blacklight_config = blacklight_config
      @user = user
    end

    def before_render
      set_slot(:search_bar, nil) unless search_bar
    end

    # Determines if the hero component should be rendered.
    # @return [Boolean]
    def render_hero?
      return false if params.key? :q

      true
    end
  end
end
