# frozen_string_literal: true

require 'system_helper'

describe 'Catalog Show Page', :solr do
  let(:item) { create(:item, published_json: json) }
  let(:solr_doc) { SolrDocument.new(item.to_solr) }

  before do
    item.add_to_solr!
    visit solr_document_path(solr_doc.id)
  end

  context 'when an item has IIIF images' do
    let(:json) { JSON.parse(json_fixture('image', 'items/api/v1/'))['data']['item'] }

    it 'shows the IIIF viewer' do
      within('.show-document') { expect(page).to have_css('.iiif-viewer-container') }
    end

    it 'shows the number of images' do
      click_on I18n.t('show.download_and_share.button')
      within('#dc-download-and-share-modal') do
        expect(page).to have_button(I18n.t('show.download_and_share.pdf.button.multiple_images', count: 12))
      end
    end

    it 'links to pdf download' do
      click_on I18n.t('show.download_and_share.button')
      within('#dc-download-and-share-modal') do
        pdf_url = "https://apotheca.library.upenn.edu/v1/items/#{item.id}/pdf"
        expect(page).to have_link('PDF — 14.8 MB', href: pdf_url)
      end
    end

    it 'links to IIIF manifest' do
      click_on I18n.t('show.download_and_share.button')
      within('#dc-download-and-share-modal') do
        manifest_url = "https://apotheca.library.upenn.edu/iiif/items/#{item.id}/manifest"
        expect(page).to have_link(manifest_url, href: manifest_url)
      end
    end
  end

  context 'when an item has no IIIF images' do
    let(:json) { JSON.parse(json_fixture('audio', 'items/api/v1/'))['data']['item'] }

    it 'does not show the IIIF viewer' do
      within('.show-document') { expect(page).not_to have_css('.iiif-viewer-container') }
    end

    it 'links to access file(s)' do
      click_on I18n.t('show.download_and_share.button')
      within('#dc-download-and-share-modal') do
        access_url = 'https://apotheca.library.upenn.edu/v1/assets/5788b27c-5987-4cec-b625-f9e289669687/access'
        expect(page).to have_link('Smaller file — mp3', href: access_url)
      end
    end

    it 'links to the preservation file' do
      click_on I18n.t('show.download_and_share.button')
      within('#dc-download-and-share-modal') do
        preservation_url = 'https://apotheca.library.upenn.edu/v1/assets/5788b27c-5987-4cec-b625-f9e289669687/preservation'
        expect(page).to have_link('Original file — wav 1.03 GB', href: preservation_url)
      end
    end
  end

  context 'when an item can be found' do
    let(:json) { JSON.parse(json_fixture('image', 'items/api/v1/'))['data']['item'] }

    before do
      click_on I18n.t('show.find_this_item.button')
    end

    context 'with the digital catalog' do
      it 'links to the record in the digital catalog' do
        within('#dc-find-this-item-modal') do
          digital_catalog_url = 'https://find.library.upenn.edu/catalog/9960736793503681'
          expect(page).to have_link(I18n.t('show.find_this_item.availability.link_text', href: digital_catalog_url))
        end
      end
    end

    context 'with physical location notes' do
      it 'shows the physical location notes' do
        solr_doc['physical_location_tesim'].each do |location|
          within('#dc-find-this-item-modal') { expect(page).to have_text(location) }
        end
      end
    end
  end

  context 'when viewing the document metadata' do
    let(:json) { JSON.parse(json_fixture('image', 'items/api/v1/'))['data']['item'] }

    it 'shows the title' do
      within('.document-main-section .documentHeader') do
        solr_doc['title_tesim'].each { |title| expect(page).to have_text(title) }
      end
    end

    it 'links to faceted search' do
      within('#document .pl-dl') do
        expect(page).to have_link('Poetry', href: search_catalog_path({ 'f[physical_format_ssim][]': 'Poetry' }))
      end
    end

    it 'links to rights uri' do
      within('#document .pl-dl') do
        rights_uri = 'http://rightsstatements.org/vocab/NoC-US/1.0/'
        expect(page).to have_link(rights_uri, href: rights_uri)
      end
    end

    it 'links to the digital catalog' do
      within('#document .pl-dl') do
        digital_catalog_url = 'https://find.library.upenn.edu/catalog/9960736793503681'
        expect(page).to have_link(I18n.t('show.digital_catalog', href: digital_catalog_url))
      end
    end

    context 'with a creator bearing a role' do
      let(:json) { build(:item_hash) }

      it 'does not include role in link to faceted search' do
        within('#document .pl-dl') do
          expect(page).to have_link('author, random (author)',
                                    href: search_catalog_path({ 'f[name_ssim][]': 'author, random' }))
        end
      end
    end
  end
end
