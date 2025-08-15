# frozen_string_literal: true

module Catalog
  # Transforms bibnumber value into links to digital catalog
  # Custom Blacklight::FieldPresenter subclass based on BL v9.0.0beta1@de5ddb
  class BibnumberPresenter < Catalog::FieldPresenter
    # @return [Array]
    def values
      @values ||= if json_request?
                    [@document.digital_catalog_url]
                  else
                    [view_context.link_to(I18n.t('show.digital_catalog'), @document.digital_catalog_url)]
                  end
    end

    # @return [Boolean]
    def render_field?
      document.digital_catalog_url.present?
    end
  end
end
