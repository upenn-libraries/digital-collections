# frozen_string_literal: true

module Catalog
  # If a link is present, transforms relation value into links and removes any redundant links that point to this item.
  # Custom Blacklight::FieldPresenter subclass based on Blacklight v9.0.0.
  class RelationPresenter < Catalog::FieldPresenter
    # @return [Array]
    def values
      @values ||= if json_request?
                    super
                  else
                    link_to_relation
                  end
    end

    # Return relation values, after removing any redundant links that point at this item.
    def retrieve_values
      redundant_link = view_context.solr_document_url(document.id)

      super.reject { |v| v.include?(redundant_link) }
    end

    private

    # Create links for relation values if a URL is present.
    #
    # Relation values are usually formatted as "text: https://example.com", we are using this format
    # to parse out the text and url.
    def link_to_relation
      retrieve_values.map do |value|
        if (match = value.match %r{(?<text>.+): (?<url>https?://.+)})
          view_context.link_to(match[:text], match[:url])
        else
          value
        end
      end
    end
  end
end
