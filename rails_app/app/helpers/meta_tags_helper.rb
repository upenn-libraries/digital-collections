# frozen_string_literal: true

# Builds the attribute hash consumed by Shared::PageMetaComponent for the
# current request: page title, description, canonical URL, OG type, and
# (for item pages) a share preview image URL.
module MetaTagsHelper
  # Maximum length of a meta description before truncation. ~160 is the practical
  # ceiling for Google search snippets and Open Graph previews.
  META_DESCRIPTION_LENGTH = 160

  # @return [Hash]
  def meta_tag_attributes
    case "#{controller_path}##{action_name}"
    when 'catalog#show' then item_meta_attributes
    else page_meta_attributes(description: I18n.t('home.hero_subheading'))
    end
  end

  private

  def page_meta_attributes(description: nil)
    {
      title: render_page_title.to_s.strip,
      description: description,
      url: canonical_url,
      type: 'website'
    }
  end

  def item_meta_attributes
    {
      title: render_page_title.to_s.strip,
      description: item_description(@document),
      url: canonical_url,
      type: 'article',
      image_url: share_preview_url(@document)
    }
  end

  def share_preview_url(document)
    return nil unless document&.preview?

    DigitalRepository.new.item_preview_url(document.id, 'size=600,600')
  end

  def item_description(document)
    raw = document&.fetch('description_tesim', [])&.compact_blank&.first
    raw&.truncate(META_DESCRIPTION_LENGTH)
  end

  def canonical_url
    request.original_url
  end
end
