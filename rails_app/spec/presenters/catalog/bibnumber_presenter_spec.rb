# frozen_string_literal: true

describe Catalog::BibnumberPresenter do
  subject(:presenter) do
    described_class.new(view_context, document, Blacklight::Configuration::IndexField.new(field: 'bibnumber_ssi'))
  end

  let(:document) { SolrDocument.new(bibnumber_ssi: '9954076003503681', id: '123') }
  let(:params) { {} }
  let(:search_state) { Blacklight::SearchState.new(params, CatalogController.blacklight_config, CatalogController.new) }
  let(:view_context) do
    instance_double(CatalogController.new.view_context.class, search_state: search_state,
                                                              blacklight_config: CatalogController.blacklight_config)
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
        expect(presenter.values).to contain_exactly document.digital_catalog_url
      end
    end

    context 'without a json request' do
      it 'transforms values into html links' do
        expect(presenter.values).to contain_exactly(
          "<a href='#{document.digital_catalog_url}'>#{I18n.t('show.digital_catalog')}</a>"
        )
        expect(view_context).to have_received(:link_to)
      end
    end
  end
end
