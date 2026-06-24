# frozen_string_literal: true

describe Catalog::RelationPresenter do
  subject(:presenter) do
    described_class.new(view_context, document, Blacklight::Configuration::IndexField.new(field: 'relation_tesim'))
  end

  let(:relation) { 'See finding aid: http://findingaids.library.upenn.edu/records/UPENN_RBML_PUSP.PRINTCOLLECTION12' }
  let(:document) { SolrDocument.new(relation_tesim: [relation], id: '123') }
  let(:params) { {} }
  let(:search_state) { Blacklight::SearchState.new(params, CatalogController.blacklight_config, CatalogController.new) }
  let(:view_context) do
    double(search_state: search_state, blacklight_config: CatalogController.blacklight_config,
           solr_document_url: 'https://example.com/items/123')
  end

  describe '#values' do
    before do
      allow(view_context).to receive(:link_to) { |text, url| "<a href='#{url}'>#{text}</a>" }
    end

    context 'with a json request' do
      let(:params) { { format: 'json' } }

      it 'does not transform values into html links' do
        expect(view_context).not_to have_received(:link_to)
      end

      it 'returns expected values' do
        expect(presenter.values).to contain_exactly relation
      end
    end

    context 'without a json request' do
      it 'transforms values into html links' do
        expect(presenter.values).to contain_exactly(
          "<a href='http://findingaids.library.upenn.edu/records/UPENN_RBML_PUSP.PRINTCOLLECTION12'>See finding aid</a>"
        )
        expect(view_context).to have_received(:link_to)
      end
    end
  end

  describe '#retrieve_values' do
    context 'when contains a redundant link' do
      let(:relation) { 'Full Resource: https://example.com/items/123' }

      it 'return empty array' do
        expect(presenter.retrieve_values).to eql []
      end
    end

    context 'when it does not contain a redundant link' do
      it 'returns relation value' do
        expect(presenter.retrieve_values).to eql [relation]
      end
    end
  end
end
