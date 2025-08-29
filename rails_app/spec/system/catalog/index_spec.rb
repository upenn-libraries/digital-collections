# frozen_string_literal: true

require 'system_helper'

describe 'Catalog Index Page', :solr do
  let(:item) { create(:item, published_json: json) }
  let(:solr_document) { SolrDocument.new(item.to_solr) }

  before { item.add_to_solr! }

  context 'with search results' do
    let(:json) { item_resource_fixture('image') }
    let(:query) { { q: item.id } }

    before { visit search_catalog_path(query) }

    it 'shows the search term' do
      within('.dc-constraints-and-sort') { expect(page).to have_text(query[:q]) }
    end

    it 'shows the number of results' do
      within('#main-container h1') { expect(page).to have_text('1 result') }
    end

    it 'links to the grid layout' do
      expect(page).not_to have_css('ol.documents-gallery')
      within('div.view-type') { click_on 'Gallery' }
      expect(page).to have_css('ol.documents-gallery')
    end

    it 'expands the collection facets' do
      within('#facets .blacklight-collection_ssim') do
        expect(page).to have_text('Allan G. Chester and Florence K. Chester Fund')
      end
    end

    it 'expands the form facets' do
      within('#facets .blacklight-physical_format_ssim') do
        expect(page).to have_text('Poetry')
      end
    end

    it 'collapses other facets' do
      within('#facets .blacklight-language_ssim') do
        expect(page).not_to have_text('Arabic')
      end
    end

    it 'shows the expected item' do
      expect(page).to have_css("#documents article.document-position-1[data-document-id='#{solr_document.id}']")
    end

    it 'links the thumbnail to the show page' do
      within('#documents .document-position-1 div.document-thumbnail') do
        expect(page).to have_link('', href: solr_document_path(solr_document))
        expect(page).to have_css("a img[src='#{solr_document.thumbnail_url}']")
      end
    end

    it 'links the title to the show page' do
      within('#documents .document-position-1 h3.document-title-heading') do
        expect(page).to have_link(solr_document['title_tesim'].to_sentence, href: solr_document_path(solr_document))
      end
    end

    it 'links to physical format facet search' do
      within('#documents article.document-position-1 dl.pl-dl--inline') do
        expect(page).to have_link('Poetry', href: search_catalog_path({ 'f[physical_format_ssim][]': 'Poetry' }))
      end
    end

    it 'links to creator facet search' do
      within('#documents article.document-position-1 .pl-dl--inline') do
        creator = 'Hilālī, Aḥmad ibn ʻAbd al-ʻAzīz, 1701-1761'
        expect(page).to have_link(creator, href: search_catalog_path({ 'f[name_ssim][]': creator }))
      end
    end

    it 'links to collection facet search' do
      within('#documents article.document-position-1 dl.pl-dl--inline') do
        collection = 'Allan G. Chester and Florence K. Chester Fund'
        expect(page).to have_link(collection, href: search_catalog_path({ 'f[collection_ssim][]': collection }))
      end
    end

    it 'shows the date' do
      within('#documents article.document-position-1 dl.pl-dl--inline') do
        expect(page).to have_text('1865')
      end
    end

    context 'with the grid layout' do
      before { visit search_catalog_path({ q: query[:q], view: 'gallery' }) }

      it 'links thumbnail to the show page' do
        within('ol.documents-gallery li.document-position-1 div.document-thumbnail') do
          expect(page).to have_link('', href: solr_document_path(solr_document))
          expect(page).to have_css("a img[src='#{solr_document.thumbnail_url}']")
        end
      end

      it 'links title to the show page' do
        within('ol.documents-gallery li.document-position-1 h3.document-title-heading') do
          expect(page).to have_link(solr_document['title_tesim'].to_sentence, href: solr_document_path(solr_document))
        end
      end

      it 'links to the physical format facet search' do
        within('ol.documents-gallery li.document-position-1 dl.document-metadata') do
          expect(page).to have_link('Poetry', href: search_catalog_path({ 'f[physical_format_ssim][]': 'Poetry' }))
        end
      end

      it 'links to the list view' do
        expect(page).not_to have_css('div.documents-list')
        within('div.view-type') { click_on 'List' }
        expect(page).to have_css('div.documents-list')
      end
    end

    context 'when an item does not have a thumbnail' do
      let(:json) { item_resource_fixture('audio') }

      it 'shows the thumbnail placeholder' do
        within('#documents .document-position-1 div.document-thumbnail') do
          expect(page).to have_css('pennlibs-fallback-img')
        end
      end
    end
  end

  context 'without search results' do
    let(:json) { item_resource_fixture('audio') }
    let(:query) { { q: 'no_result' } }

    before { visit search_catalog_path(query) }

    it 'shows the no results header' do
      within('#main-container h1') { expect(page).to have_text(I18n.t('results.h1.none')) }
    end

    it 'shows the no results suggestions' do
      within('#content div.alert h2') { expect(page).to have_text(I18n.t('results.none.h2')) }
      within('#content div.alert ul') { expect(page).to have_text(I18n.t('results.none.adjust_search')) }
    end
  end
end
