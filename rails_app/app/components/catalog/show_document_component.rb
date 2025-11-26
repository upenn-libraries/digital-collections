# frozen_string_literal: true

module Catalog
  # Override DocumentComponent from Blacklight 9.0.0.beta8 to
  #  - add Clover IIIF Viewer
  #  - render DocumentActions component
  class ShowDocumentComponent < Blacklight::DocumentComponent
    renders_one :document_actions, DocumentActionsComponent

    def before_render
      super
      with_document_actions(document: @document) unless document_actions
    end
  end
end
