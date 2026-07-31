# frozen_string_literal: true

module Catalog
  # Override DocumentComponent from Blacklight v9.0.0 to
  #  - add Clover IIIF Viewer
  #  - render DocumentActions component
  class ShowDocumentComponent < Blacklight::DocumentComponent
    renders_one :document_actions, DocumentActionsComponent

    SKELETON_THUMBNAIL_COUNT = 7
    SIMULATED_VIEWER_STATES = %w[loading error].freeze

    def before_render
      super
      with_document_actions(document: @document) unless document_actions
    end

    # @return [Boolean]
    def render_skeleton_thumbs?
      @document.iiif_image_count > 1
    end

    # @return [String, nil]
    def simulated_viewer_state
      return nil if Rails.env.production?

      SIMULATED_VIEWER_STATES.find { |state| state == helpers.params[:viewer_state] }
    end
  end
end
