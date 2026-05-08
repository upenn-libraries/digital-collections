# frozen_string_literal: true

require 'rails_helper'

describe Shared::PageMetaComponent, type: :component do
  it 'renders all expected tags from full inputs' do
    rendered = render_inline(described_class.new(
      title: 'A Page',
      description: 'A useful description.',
      image_url: 'https://example.com/share.jpg',
      url: 'https://example.com/x',
      type: 'article'
    ))
    expect(rendered.css('meta[name="description"]').first['content']).to eq 'A useful description.'
    expect(rendered.css('meta[property="og:title"]').first['content']).to eq 'A Page'
    expect(rendered.css('meta[property="og:type"]').first['content']).to eq 'article'
    expect(rendered.css('meta[property="og:url"]').first['content']).to eq 'https://example.com/x'
    expect(rendered.css('meta[property="og:image"]').first['content']).to eq 'https://example.com/share.jpg'
    expect(rendered.css('link[rel="canonical"]').first['href']).to eq 'https://example.com/x'
  end

  it 'omits optional tags when their inputs are nil' do
    rendered = render_inline(described_class.new(description: nil, image_url: nil, url: nil))
    expect(rendered.css('meta[name="description"]')).to be_empty
    expect(rendered.css('meta[property="og:description"]')).to be_empty
    expect(rendered.css('link[rel="canonical"]')).to be_empty
    expect(rendered.css('meta[property="og:image"]')).to be_empty
  end

  it 'falls back to site_name for og:title and rejects unknown og:type values' do
    rendered = render_inline(described_class.new(title: nil, type: 'something-else'))
    expect(rendered.css('meta[property="og:title"]').first['content']).to eq I18n.t('header.service_name')
    expect(rendered.css('meta[property="og:type"]').first['content']).to eq 'website'
  end
end
