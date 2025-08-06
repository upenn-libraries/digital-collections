# frozen_string_literal: true

module DC
  # Override DocumentComponent from Blacklight 9.0.0beta1 to
  #  - add Clover IIIF Viewer
  #  - render DownloadAndShare component
  class ShowDocumentComponent < Blacklight::DocumentComponent
    renders_one :download_and_share, DC::DownloadAndShareComponent
  end
end
