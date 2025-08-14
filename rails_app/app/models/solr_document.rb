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

  # Returns true if PDF is available
  #
  # @return [Boolean]
  def pdf?
    fetch(:has_pdf_bsi, false)
  end

  # PDF URL
  #
  # @return [String]
  def pdf_url
    "#{Settings.digital_repository.url}#{Settings.digital_repository.api.resource.path}/#{id}/pdf"
  end

  # IIIF manifest URL.
  #
  # @return [String]
  def manifest_url
    "#{Settings.digital_repository.url}/iiif/items/#{id}/manifest"
  end

  # @return [Integer]
  def iiif_image_count
    fetch(:iiif_image_count_isi, 0)
  end

  # @return [Array<Hash>]
  def non_iiif_assets
    assets = fetch(:non_iiif_asset_listing_ss, '[]')

    JSON.parse assets
  end

  # @return [Hash]
  def pdf
    JSON.parse fetch(:pdf_ss, '{}')
  end

  # @return [String, nil]
  def bibnumber
    fetch(:bibnumber_ssi, nil)
  end

  # @return [String, nil]
  def digital_catalog_url
    return unless bibnumber

    URI::HTTPS.build(host: Settings.digital_catalog.url, path: "#{Settings.digital_catalog.path}/#{bibnumber}").to_s
  end
end
