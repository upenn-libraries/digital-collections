# frozen_string_literal: true

# Renders modal with links download non IIIF assets and Item derivatives
class DownloadAndShareComponent < ViewComponent::Base
  renders_one :persistent_url, DownloadAndShare::PersistentUrlComponent
  renders_one :pdf_download, DownloadAndShare::PDFDownloadComponent
  renders_one :iiif_manifest, DownloadAndShare::IIIFManifestComponent
  renders_one :file_download, DownloadAndShare::FileDownloadComponent

  def initialize(document:)
    @document = document
  end

  # set default slot components
  def before_render
    with_persistent_url(document: @document) unless persistent_url
    with_pdf_download(document: @document) unless pdf_download
    with_iiif_manifest(document: @document) unless iiif_manifest
    with_file_download(document: @document) unless file_download
  end
end
