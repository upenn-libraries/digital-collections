# frozen_string_literal: true

# Class containing indexing logic for Items.
class ItemIndexer
  attr_reader :data

  FACET_FIELDS = %i[physical_format language subject collection geographic_subject item_type].freeze

  # @param data [Hash] item json
  def initialize(data)
    @data = data.deep_symbolize_keys
  end

  # Returns Solr document that can be committed to Solr
  #
  # @return [Hash]
  def to_solr
    document = {
      id: data[:id],
      ark_ssi: data[:ark],
      first_published_at_dtsi: data[:first_published_at],
      last_published_at_dtsi: data[:last_published_at]
    }

    add_descriptive_metadata(document)
    add_asset_information(document)
    add_derivative_information(document)

    document
  end

  private

  # Add the values that we want to display from the descriptive metadata.
  def add_descriptive_metadata(document)
    data.fetch(:descriptive_metadata, []).each do |field, values|
      next if values.blank?

      case field
      when :date
        date_indexers = values.pluck(:value).map { |value| EDTFIndexer.new(value) }

        document[:date_ssim] = date_indexers.map(&:humanize)
        document[:year_isim] = date_indexers.map(&:years).flatten
      when :rights # extracting URI for rights
        document[:rights_uri_ssim] = values.pluck(:uri)
      when :name
        document[:name_ssim] = values.pluck(:value)

        document[:name_with_role_tesim] = values.map do |name|
          roles = name.fetch(:role, []).map { |r| r[:value] }.map(&:downcase).uniq
          roles.blank? ? name[:value] : "#{name[:value]} (#{roles.join(', ')})"
        end
      when :bibnumber
        document[:bibnumber_ssi] = values.pluck(:value)
      when *FACET_FIELDS
        document[:"#{field}_ssim"] = values.pluck(:value)
        document[:"#{field}_tesim"] = values.pluck(:value)
      else
        document[:"#{field}_tesim"] = values.pluck(:value)
      end
    end
  end

  # Add necessary asset information.
  def add_asset_information(document)
    # Extract assets that need to be listed instead of displayed via the IIIF manifest.
    document[:non_iiif_asset_listing_ss] = data.fetch(:assets, [])
                                               .reject { |a| a[:preservation_file][:mime_type] == 'image/tiff' }
                                               .to_json
  end

  # Add derivative information.
  def add_derivative_information(document)
    document[:has_preview_bsi] = data.dig(:derivatives, :preview).present?
    document[:has_iiif_manifest_bsi] = data.dig(:derivatives, :iiif_manifest).present?
  end
end
