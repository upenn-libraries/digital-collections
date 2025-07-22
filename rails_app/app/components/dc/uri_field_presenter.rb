# frozen_string_literal: true

module DC
  # Ensures URI fields render as hyperlinks
  # Custom Blacklight::FieldPresenter subclass based on BL v9.0.0beta1@de5ddb
  class URIFieldPresenter < Blacklight::FieldPresenter
    def values
      @values ||= retrieve_values.map { |value| @view_context.link_to(value, value) }
    end
  end
end
