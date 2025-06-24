# frozen_string_literal: true

# Class to find, create and delete Items.
#
# Each item has a representation in the database (which includes the full json payload we receive) and in Solr (which
# indexes the data in the database for display purposes).
class Item < ApplicationRecord
  REQUIRED_KEYS = %w[id ark first_published_at last_published_at descriptive_metadata assets].freeze

  validates :published_json, presence: true
  validate :required_keys_present

  # Ensuring the minimum required fields are present in the published_json
  def required_keys_present
    return if published_json.blank?

    missing_keys = REQUIRED_KEYS - published_json.keys

    return if missing_keys.blank?

    errors.add(:published_json, "missing the following key(s): #{missing_keys.join(', ')}")
  end

  # Add Item to Solr.
  def add_solr_document!
    raise ArgumentError, 'publish_json must be present in order to add document to Solr' if published_json.blank?

    solr = RSolr.connect(url: Settings.solr.url)
    solr.add(solr_document)
    solr.commit
  end

  # Delete Item from Solr.
  def remove_solr_document!
    solr = RSolr.connect(url: Settings.solr.url)
    solr.delete_by_query "id:#{id}"
    solr.commit
  end

  # Returns Solr document that can be committed to Solr
  #
  # @return [Hash] solr_document
  def solr_document
    document = {
      id: published_json['id'],
      ark_ssi: published_json['ark'],
      first_published_at_dtsi: published_json['first_published_at'],
      last_published_dtsi: published_json['last_published_at'],
      preview_bsi: published_json.dig('derivatives', 'preview').present?,
      iiif_manifest_bsi: published_json.dig('derivatives', 'iiif_manifest').present?,
      name_ssim: [],
      name_with_role_tesim: []
    }

    # Extract assets that need to be listed instead of displayed via the IIIF manifest.
    published_json['non_iiif_asset_listing_ss'] = published_json.fetch('assets', [])
                                                                .select { |a| a['preservation_file']['mime_type'] != 'image/tiff' }
                                                                .to_json

    # Extract the values that we want to display from the descriptive metadata.
    published_json.fetch('descriptive_metadata', []).each do |field, values|
      next if values.blank?

      case field
      when 'date'
        dates = values.pluck('value')

        document[:date_ssim] = dates&.map do |value|
          if value.match?(/^\d\d(\d|X)X$/)
            "#{value.tr('X', '0')}s"
          else
            value
          end
        end

        document[:year_isim] = dates&.sum([]) do |value|
          if value.match?(/^\d\d(\d|X)X$/) # 10XX, 100X
            Range.new(value.tr('X', '0').to_i, value.tr('X', '9').to_i).to_a.map(&:to_s)
          elsif value.match?(/^\d\d\d\d(-\d\d(-\d\d)?)?$/) # 2002, 2002-02, 2002-02-02
            Array.wrap(value[0..3])
          else
            []
          end
        end
      when 'rights' # extracting URI for rights
        document[:rights_uri_ssim] = values.pluck('uri')
      when 'name'
        values.each do |name|
          roles = name.fetch('role', []).map { |r| r['value'] }.map(&:downcase).uniq
          name_with_role = roles.blank? ? name['value'] : "#{name['value']} (#{roles.join(', ')})"

          document[:name_ssim] << name['value']
          document[:name_with_role_tesim] << name_with_role
        end
      when 'bibnumber'
        document[:bibnumber_ssi] = values.pluck('value')
      when 'physical_format', 'language', 'subject', 'collection' # facets
        document[:"#{field}_ssim"] = values.pluck('value')
        document[:"#{field}_tesim"] = values.pluck('value')
      else
        document[:"#{field}_tesim"] = values.pluck('value')
      end
    end

    document
  end
end
