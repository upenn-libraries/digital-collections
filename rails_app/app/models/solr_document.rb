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
  #
  # @return [Boolean]
  def preview?
    fetch(:has_preview_bsi, false)
  end

  # Returns true if IIIF manifest is available
  #
  # @return [Boolean]
  def manifest?
    fetch(:has_iiif_manifest_bsi, false)
  end

  # IIIF manifest URL.
  #
  # @return [String]
  def manifest_url
    "#{Settings.digital_repository.url}/iiif/items/#{id}/manifest"
  end
end
