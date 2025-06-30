# frozen_string_literal: true

# Class to find, create and delete Items.
#
# Each item has a representation in the database (which includes the full json payload we receive) and in Solr (which
# indexes the data in the database for display purposes).
class Item < ApplicationRecord
  include Indexable

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

  def to_solr
    ItemIndexer.new(published_json).to_solr
  end
end
