# frozen_string_literal: true

require 'rails_helper'

describe 'Page meta tags' do
  describe 'a non-item page' do
    before { get '/' }

    it 'renders the standard meta tags but no og:image' do
      aggregate_failures do
        expect(response.body).to include '<meta name="description"'
        expect(response.body).to include 'property="og:title"'
        expect(response.body).to include 'property="og:type"'
        expect(response.body).to include 'property="og:site_name"'
        expect(response.body).not_to include 'property="og:image"'
      end
    end

    it 'strips whitespace captured by content_for from og:title' do
      og_title = response.body[/property="og:title" content="([^"]+)"/, 1]
      expect(og_title).to eq og_title.strip
    end
  end

  describe 'an item show page', :solr do
    let(:item) { create(:item, published_json: item_resource_fixture('image')) }

    before do
      item.add_to_solr!
      get solr_document_path(item.id)
    end

    it 'renders og:image pointing at the digital repository preview proxy' do
      expect(response.body).to include(
        %(property="og:image" content="https://#{Settings.digital_repository.host}/v1/items/#{item.id}/preview?size=600,600")
      )
    end
  end
end
