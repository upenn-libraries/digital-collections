# frozen_string_literal: true

module DC
  # Override DocumentComponent from Blacklight 9.0.0beta1 to add Clover IIIF Viewer
  class ShowDocumentComponent < Blacklight::DocumentComponent; end
  # file download component listing download links for all non IIIF assets
  renders_one :file_download, ->(assets: @document.non_iiif_assets) { DC::FileDownloadComponent.new(assets: assets) }
end
