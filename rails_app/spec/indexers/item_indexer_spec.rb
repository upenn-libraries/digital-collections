# frozen_string_literal: true

describe ItemIndexer do
  describe '#solr_document' do
    let(:uuid) { '62ad79cf-2264-4841-ae4e-84b58d66248e' }

    context 'with iiif assets' do
      subject(:indexer) { build(:item_indexer) }

      it 'document contains expected fields' do
        expect(indexer.solr_document).to include(
          id: '36a224db-c416-4769-9da1-28513827d179',
          ark_ssi: 'ark:/99999/fk4pp0qk3c',
          first_published_at_dtsi: '2023-01-03T14:27:35Z',
          last_published_at_dtsi: '2024-01-03T11:22:30Z',
          preview_bsi: true,
          iiif_manifest_bsi: true,
          non_iiif_asset_listing_ss: '[]',
          name_ssim: [
            'creator, random', 'author, random', 'contributor, random', 'random, person', 'second random, person'
          ],
          name_with_role_tesim: [
            'creator, random (creator)', 'author, random (author)', 'contributor, random (contributor)',
            'random, person', 'second random, person (illustrator)'
          ],
          title_tesim: ['Message from Phanias and others of the agoranomoi of Oxyrhynchus about a purchase of land.'],
          collection_tesim: ['University of Pennsylvania Papyrological Collection'],
          collection_ssim: ['University of Pennsylvania Papyrological Collection'],
          rights_uri_ssim: ['http://rightsstatements.org/vocab/NoC-US/1.0/'],
          date_ssim: ['2002-02-01', '2003', '1990s', 'ca. 2000'],
          year_isim: %w[2002 2003 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999]
        )
      end
    end

    context 'with non-iiif assets' do
      let(:indexer) { create(:item_indexer, :video) }

      it 'document contains expected fields' do
        expect(indexer.solr_document).to include(
          id: '36a224db-c416-4769-9da1-28513827d179',
          ark_ssi: 'ark:/99999/fk4pp0qk3c',
          first_published_at_dtsi: '2023-01-03T14:27:35Z',
          last_published_at_dtsi: '2024-01-03T11:22:30Z',
          preview_bsi: true,
          iiif_manifest_bsi: false
        )
      end

      it 'document contains non-iiif assets listing' do
        non_iiif_asset_listing = JSON.parse(indexer.solr_document[:non_iiif_asset_listing_ss])
        non_iiif_asset_listing.first.deep_symbolize_keys!
        expect(non_iiif_asset_listing).to eql indexer.data[:assets]
      end
    end
  end
end
