# frozen_string_literal: true

# Concern with methods to add or remove a Solr document.
#
# Requires that a `to_solr` method is present in the model.
module Indexable
  extend ActiveSupport::Concern

  # Add document to Solr.
  def add_to_solr!
    solr = RSolr.connect(url: Settings.solr.url)
    solr.add(to_solr)
    solr.commit
  end

  # Delete document from Solr.
  def remove_from_solr!
    solr = RSolr.connect(url: Settings.solr.url)
    solr.delete_by_query "id:#{id}"
    solr.commit
  end
end
