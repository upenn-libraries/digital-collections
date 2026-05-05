# frozen_string_literal: true

require 'rails_helper'

describe SearchBuilder do
  subject(:search_builder) { described_class.new(scope).with(blacklight_params) }

  # user params coming from the search state
  let(:blacklight_params) { {} }
  # solr friendly processed params passed down the search builder processor chain
  let(:solr_params) { {} }

  let(:blacklight_config) { CatalogController.blacklight_config }
  let(:scope) { instance_double CatalogController, blacklight_config: blacklight_config, action_name: 'index' }

  describe '#masssage_sort' do
    before { search_builder.massage_sort(solr_params) }

    context 'with a search term provided' do
      context 'with a relevance sort' do
        let(:solr_params) { { q: 'term', sort: 'score desc' } }

        it 'does not alter the sort value' do
          expect(solr_params[:sort]).to eq 'score desc'
        end
      end

      context 'without a relevance sort' do
        let(:solr_params) { { q: 'term', sort: 'title_sort asc' } }

        it 'does not alter the sort value' do
          expect(solr_params[:sort]).to eq 'title_sort asc'
        end
      end
    end

    context 'without a search term provided' do
      context 'with a relevance sort' do
        let(:solr_params) { { sort: 'score desc' } }

        it 'alters the sort parameter' do
          expect(solr_params[:sort]).to eq 'first_published_at_dtsi desc'
        end
      end

      context 'without a relevance sort' do
        let(:solr_params) { { sort: 'title_sort asc' } }

        it 'does not alter the sort value' do
          expect(solr_params[:sort]).to eq 'title_sort asc'
        end
      end
    end
  end
end
