# frozen_string_literal: true

describe 'Catalog Controller Requests' do
  describe '#legacy_redirect', :solr do
    let(:item) { create(:item, published_json: json) }
    let(:json) { item_resource_fixture('image') }
    let(:legacy_path) { '/catalog/81431-p3sj1b55t' }

    before do
      item.add_to_solr!
      get legacy_path
    end

    it 'redirects to show page' do
      expect(response.status).to eq 302
      expect(response).to redirect_to(solr_document_path(item.id))
    end
  end
end
