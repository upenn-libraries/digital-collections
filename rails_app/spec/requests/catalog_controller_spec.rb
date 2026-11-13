# frozen_string_literal: true

describe 'Catalog Controller Requests' do
  describe '#legacy_redirect', :solr do
    let(:item) { create(:item, published_json: json) }
    let(:json) { item_resource_fixture('image') }

    before do
      item.add_to_solr!
      get "/catalog/#{normalized_ark}"
    end

    context 'when record present' do
      let(:normalized_ark) { '81431-p3sj1b55t' }

      it 'redirects to show page' do
        expect(response.status).to eq 302
        expect(response).to redirect_to(solr_document_path(item.id))
      end
    end

    context 'when record not present' do
      let(:normalized_ark) { 'invalid' }

      it 'renders 404' do
        expect(response.status).to eq 404
      end
    end
  end
end
