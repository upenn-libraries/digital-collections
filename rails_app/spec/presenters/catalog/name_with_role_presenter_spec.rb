# frozen_string_literal: true

describe Catalog::NameWithRolePresenter do
  subject(:presenter) do
    described_class.new(view_context, document,
                        Blacklight::Configuration::IndexField.new(field: 'name_with_role_tesim', limit: nil))
  end

  let(:document) do
    SolrDocument.new(
      name_with_role_tesim: ['Some institution (issuing body)', 'Some writer (creator)'],
      name_ssim: ['Some institution', 'Some writer'],
      id: '123'
    )
  end
  let(:params) { {} }
  let(:search_state) { Blacklight::SearchState.new(params, CatalogController.blacklight_config, CatalogController.new) }
  let(:view_context) do
    instance_double(CatalogController.new.view_context.class, search_state: search_state,
                                                              blacklight_config: CatalogController.blacklight_config)
  end

  describe '#values' do
    before do
      allow(view_context).to receive(:search_action_path) { |f| "/items?#{f.keys.first}=#{f.values.first}" }
      allow(view_context).to receive(:link_to) { |text, url| "<a href='#{url}'>#{text}</a>" }
    end

    context 'with a json request' do
      let(:params) { { format: 'json' } }

      it 'does not transform values into html links' do
        expect(view_context).not_to have_received(:link_to)
      end

      it 'places creators first' do
        expect(presenter.values).to eq ['Some writer (creator)', 'Some institution (issuing body)']
      end
    end

    context 'without a json request' do
      it 'transforms values into facet search links' do
        expect(presenter.values).to contain_exactly(
          "<a href='/items?f[name_ssim][]=Some writer'>Some writer (creator)</a>",
          "<a href='/items?f[name_ssim][]=Some institution'>Some institution (issuing body)</a>"
        )
        expect(view_context).to have_received(:link_to).twice
      end
    end

    context 'when there is a limit' do
      let(:presenter) do
        described_class.new(view_context, document,
                            Blacklight::Configuration::IndexField.new(field: 'name_with_role_tesim', limit: 1))
      end

      it 'limits the amount of values returned' do
        expect(presenter.values).to eq ["<a href='/items?f[name_ssim][]=Some writer'>Some writer (creator)</a>"]
      end
    end

    context 'when there are a different number of display values and facet values' do
      let(:document) do
        SolrDocument.new(
          name_with_role_tesim: ['Some institution (issuing body)', 'Some writer (creator)'],
          name_ssim: ['Some institution'],
          id: '123'
        )
      end

      it 'raises an error' do
        expect { presenter.values }.to raise_error(
          ArgumentError,
          'Mismatch between name_with_role_tesim (2) and name_ssim (1) in document 123'
        )
      end
    end
  end
end
