# frozen_string_literal: true

module DC
  # Renders modal with links download non IIIF assets and Item derivatives
  class DownloadAndShareComponent < ViewComponent::Base
    renders_one :asset_download_list, DC::DownloadAndShare::AssetDownloadListComponent
    renders_one :item_derivatives, DC::DownloadAndShare::ItemDerivativesAccordionComponent
    def initialize(document:)
      @document = document
    end

    # set default slot components
    def before_render
      with_asset_download_list(assets: @document.non_iiif_assets) unless asset_download_list
      with_item_derivatives(document: @document) unless item_derivatives
    end
  end
end
