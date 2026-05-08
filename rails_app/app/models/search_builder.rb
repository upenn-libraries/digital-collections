# frozen_string_literal: true

# Extends Blacklight::SearchBuilder for added functionality
class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior
  include BlacklightRangeLimit::RangeLimitBuilder

  self.default_processor_chain += [:massage_sort]

  # Sort by newest items when a blank query is set to be sorted by relevance score.
  # @param solr_parameters [Hash] the current solr parameters
  def massage_sort(solr_parameters)
    return if solr_parameters[:q].present? || non_relevance_sort?(solr_parameters)

    solr_parameters[:sort] = 'first_published_at_dtsi desc'
  end

  private

  # @param solr_parameters [Hash]
  # @return [Boolean]
  def non_relevance_sort?(solr_parameters)
    solr_parameters[:sort].present? && solr_parameters[:sort] != 'score desc'
  end
end
