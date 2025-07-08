# frozen_string_literal: true

module BlacklightHelper
  include Blacklight::BlacklightHelperBehavior

  # Overriding Blacklight::LayoutHelperBehavior#container to support using full-width layout
  # for selected pages.
  #
  # Setting config.full_width_layout in CatalogController will no longer have an effect.
  #
  # @return [String]
  def container_classes
    action_name == 'index' ? 'container-fluid' : 'container'
  end
end