# frozen_string_literal: true

describe 'Sitemap Controller Requests' do
  let(:item) { create(:item, published_json: item_resource_fixture('image')) }
  let(:parsed_body) do
    xml = Nokogiri::XML(response.body)
    xml.remove_namespaces!
    xml
  end

  before { item.add_to_solr! }

  describe '#index', :solr do
    before { get blacklight_dynamic_sitemap.sitemap_index_path }

    it 'renders XML with root element' do
      expect(parsed_body.at_xpath('//sitemapindex/sitemap')).to be_truthy
    end
  end

  describe '#show', :solr do
    before { get blacklight_dynamic_sitemap.sitemap_path('0') }

    it 'renders XML with root element' do
      expect(parsed_body.at_xpath('//urlset')).to be_truthy
    end
  end
end
