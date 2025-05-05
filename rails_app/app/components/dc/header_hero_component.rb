# frozen_string_literal: true

# copied from Blacklight 9

module DC
  # Override Header Component
  class HeaderHeroComponent < Blacklight::Component
    attr_accessor :blacklight_config, :user, :image_url

    renders_one :search_bar, lambda { |component: DC::SearchNavbarComponent|
      component.new(blacklight_config: blacklight_config)
    }

    renders_one :user_tools, lambda {
      UserToolsComponent.new(user: user)
    }

    renders_one :heading
    renders_one :subheading

    # @param blacklight_config [Blacklight::Configuration]
    # @param user [User]
    def initialize(blacklight_config:, user:, image_url:)
      @blacklight_config = blacklight_config
      @user = user
      @image_url = image_url
    end

    def before_render
      set_slot(:search_bar, nil) unless search_bar
      set_slot(:user_tools, nil) unless user_tools
      set_slot(:heading, nil) unless heading
      set_slot(:subheading, nil) unless subheading
    end
  end
end
