# frozen_string_literal: true

# Concern with methods to add or remove a Solr document.
#
# Requires that a `to_solr` method is present in the model.
module Indexable
  extend ActiveSupport::Concern

  # Add document to Solr.
  # Using commitWithin if configuration is present, otherwise doing an explicit hard commit.
  def add_to_solr!
    commit_within = Settings.solr.commit_within
    options = commit_within ? { add_attributes: { commitWithin: commit_within } } : {}

    solr.add(to_solr, **options)
    solr.commit unless commit_within
  end

  # Delete document from Solr.
  def remove_from_solr!
    solr.delete_by_query "id:#{id}"
    solr.commit
  end

  private

  def solr
    @solr ||= RSolr.connect(url: Settings.solr.url)
  end
end
