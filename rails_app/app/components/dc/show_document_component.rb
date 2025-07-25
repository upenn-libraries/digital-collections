# frozen_string_literal: true

module DC
  # Override DocumentComponent from Blacklight 9.0.0beta1 to add Clover IIIF Viewer
  class ShowDocumentComponent < Blacklight::DocumentComponent
    def manifest_url
      "#{Settings.digital_repository.url}/iiif/items/#{@document.id}/manifest"
    end
  end
end
