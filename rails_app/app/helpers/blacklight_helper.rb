# frozen_string_literal: true

# Overriding Blacklight helper methods.
module BlacklightHelper
  include Blacklight::BlacklightHelperBehavior

  # Overriding Blacklight::LayoutHelperBehavior#container v9.0.0.beta4 to support using full-width layout
  # for selected pages.
  #
  # Setting config.full_width_layout in CatalogController will no longer have an effect.
  #
  # @return [String]
  def container_classes
    %w[index collections].include?(action_name) ? 'container-fluid' : 'container'
  end
end
