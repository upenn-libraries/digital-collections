# frozen_string_literal: true

# Renders call to actions
class DocumentActionsComponent < ViewComponent::Base
  renders_one :download_and_share, DownloadAndShareComponent
  renders_one :find_this_item, FindThisItemComponent

  # @param document [SolrDocument]
  def initialize(document:)
    @document = document
  end

  # @return [Boolean]
  def render?
    download_and_share.present? || find_this_item.present?
  end

  # render default slots
  def before_render
    with_download_and_share(document: @document) unless download_and_share
    with_find_this_item(document: @document) unless find_this_item
  end
end
