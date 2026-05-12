# frozen_string_literal: true

module Shared
  # Renders HTML <head> meta tags for description, Open Graph, and canonical URL.
  class PageMetaComponent < ViewComponent::Base
    OG_TYPES = %w[website article].freeze

    # @param title [String, nil] page title; falls back to the configured site name
    # @param description [String, nil] page description
    # @param image_url [String, nil] absolute URL of the share card image
    # @param url [String, nil] absolute canonical URL of the page
    # @param type [String] Open Graph type (website or article)
    def initialize(title: nil, description: nil, image_url: nil, url: nil, type: 'website')
      @title = title
      @description = description
      @image_url = image_url
      @url = url
      @type = OG_TYPES.include?(type) ? type : 'website'
    end

    private

    attr_reader :description, :image_url, :url, :type

    def title
      @title.presence || site_name
    end

    def site_name
      I18n.t('header.service_name')
    end
  end
end
