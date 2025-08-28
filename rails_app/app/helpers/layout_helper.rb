# frozen_string_literal: true

# Helper methods for layouts
# Overriding helpers methods in Blacklight 9.0.0.beta7
module LayoutHelper
  include Blacklight::LayoutHelperBehavior

  # Classes used for sizing the main content of a Blacklight page
  # Make the content (and viewer) take up the whole width of the page
  # @return [String]
  def main_content_classes
    'col-lg-12'
  end

  # Classes used for sizing the sidebar content of a Blacklight page
  # Removed `col-lg-3` so there's no conflict with the main content
  # @return [String]
  def sidebar_classes
    'page-sidebar'
  end

  # Overriding method to support using full-width layout for selected pages.
  #
  # Setting config.full_width_layout in CatalogController will no longer have an effect.
  #
  # @return [String]
  def container_classes
    %w[index collections home].include?(action_name) ? 'container-fluid' : 'container'
  end
end
