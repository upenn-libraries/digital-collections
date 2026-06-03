# frozen_string_literal: true

module Catalog
  # Search-results title component. Subclasses Blacklight's default so we
  # can wrap the title in pennlibs-expand-text and clamp very long titles.
  # Wired via config.index.document_title_component in CatalogController.
  class IndexDocumentTitleComponent < Blacklight::DocumentTitleComponent; end
end
