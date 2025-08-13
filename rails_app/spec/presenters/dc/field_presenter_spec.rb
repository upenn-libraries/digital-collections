# frozen_string_literal: true

describe DC::FieldPresenter do
  subject(:presenter) { described_class.new(view_context, SolrDocument.new, field_config) }

  let(:search_state) { Blacklight::SearchState.new(params, CatalogController.blacklight_config, CatalogController.new) }
  let(:view_context) do
    instance_double(CatalogController.new.view_context.class, search_state: search_state,
                                                              blacklight_config: CatalogController.blacklight_config)
  end
  let(:params) { {} }

  describe '#initialize' do
    let(:field_config) do
      Blacklight::Configuration::IndexField.new(field: 'format', key: 'format', values: ->(_, _, _) { %w[a b] })
    end

    it 'adds the join step to the except_operations array' do
      expect(presenter.except_operations).to contain_exactly Blacklight::Rendering::Join
    end

    context 'with a json request' do
      let(:params) { { format: 'json' } }

      it 'adds the link to facet rendering step to the except_operations array' do
        expect(presenter.except_operations).to contain_exactly(Blacklight::Rendering::Join,
                                                               Blacklight::Rendering::LinkToFacet)
      end
    end
  end

  describe '#render' do
    context 'with a single valued field' do
      let(:field_config) do
        Blacklight::Configuration::IndexField.new(field: 'id', values: ->(_, _, _) { '123456789' })
      end

      it 'returns an unjoined Array' do
        expect(presenter.render).to eq ['123456789']
      end
    end

    context 'with a multi-valued field' do
      let(:field_config) do
        Blacklight::Configuration::IndexField.new(field: 'format', values: ->(_, _, _) { %w[a b] })
      end

      it 'returns an unjoined Array' do
        expect(presenter.render).to eq %w[a b]
      end
    end

    context 'when link_to_facet is configured' do
      let(:field_config) do
        Blacklight::Configuration::IndexField.new(field: 'format', values: ->(_, _, _) { %w[a] },
                                                  link_to_facet: true)
      end

      before do
        allow(view_context).to receive(:search_action_path).and_return('/items?f[format][]=a')
        allow(view_context).to receive(:link_to) { |text, url| "<a href='#{url}'>#{text}</a>" }
      end

      context 'with a json request' do
        let(:params) { { format: 'json' } }

        it "doesn't call the link to facet step" do
          presenter.render
          expect(view_context).not_to have_received(:search_action_path)
          expect(view_context).not_to have_received(:link_to)
        end

        it 'does not render facet search links' do
          expect(presenter.render).to eq %w[a]
        end
      end

      context 'without a json request' do
        it 'renders facet search links' do
          expect(presenter.render).to eq ["<a href='/items?f[format][]=a'>a</a>"]
        end
      end
    end
  end
end
