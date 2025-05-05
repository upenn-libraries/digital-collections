# frozen_string_literal: true

# copied from Blacklight 9

module DC
  # Override Header Component
  class HeaderHeroComponent < Blacklight::Component
    attr_accessor :blacklight_config, :user, :image_url, :heading, :subheading

    renders_one :search_bar, lambda { |component: DC::SearchNavbarComponent|
      component.new(blacklight_config: blacklight_config)
    }

    renders_one :user_tools, lambda {
      UserToolsComponent.new(user: user)
    }

    # @param blacklight_config [Blacklight::Configuration]
    # @param user [User]
    def initialize(blacklight_config:, user:, image_url:, heading:, subheading:)
      @blacklight_config = blacklight_config
      @user = user
      @image_url = image_url
      @heading = heading
      @subheading = subheading
    end

    def before_render
      set_slot(:search_bar, nil) unless search_bar
      set_slot(:user_tools, nil) unless user_tools
    end
  end
end
