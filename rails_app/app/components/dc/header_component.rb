# frozen_string_literal: true

module DC
  # This is a custom header component that render a search bar and user tools.
  # It's used in two places:
  # 1. We set the header to this component in the catalog controller to render on all Blacklight pages.
  # 2. We tell the base Blacklight layout to render the HeroComponent on static pages,
  #    which has a slot for this component.
  class HeaderComponent < Blacklight::Component
    attr_accessor :blacklight_config, :user, :theme

    renders_one :search_bar, lambda { |component: DC::SearchNavbarComponent|
      component.new(blacklight_config: blacklight_config)
    }

    renders_one :user_tools, lambda {
      UserToolsComponent.new(user: user)
    }

    # @param blacklight_config [Blacklight::Configuration]
    # @param user [User]
    def initialize(blacklight_config:, user:, theme: :light)
      @blacklight_config = blacklight_config
      @user = user
      @theme = theme
    end

    def before_render
      set_slot(:search_bar, nil) unless search_bar
      set_slot(:user_tools, nil) unless user_tools
    end
  end
end
