# frozen_string_literal: true

# Represents a single document returned from Solr
class SolrDocument
  include Blacklight::Solr::Document

  # self.unique_key = 'id'

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  # Returns true if preview is available
  def preview?
    fetch(:has_preview_bsi, false)
  end

  # @return [Array<Hash>]
  def non_iiif_assets
    assets = fetch(:non_iiif_asset_listing_ss, '[]')

    JSON.parse assets
  end
end
