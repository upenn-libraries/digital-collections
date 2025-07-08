# frozen_string_literal: true

FactoryBot.define do
  factory :item_indexer, class: 'ItemIndexer' do
    id { '36a224db-c416-4769-9da1-28513827d179' }
    ark { 'ark:/99999/fk4pp0qk3c' }
    first_published_at { '2023-01-03T14:27:35Z' }
    last_published_at { '2024-01-03T11:22:30Z' }

    descriptive_metadata do
      {
        title: [
          { value: 'Message from Phanias and others of the agoranomoi of Oxyrhynchus about a purchase of land.' }
        ],
        collection: [{ value: 'University of Pennsylvania Papyrological Collection' }],
        name: [
          { value: 'creator, random', role: [{ value: 'creator' }] },
          { value: 'author, random', role: [{ value: 'author' }] },
          { value: 'contributor, random', role: [{ value: 'contributor' }] },
          { value: 'random, person', role: [] },
          { value: 'second random, person', role: [{ value: 'illustrator' }] }
        ],
        rights: [{ value: 'No Copyright', uri: 'http://rightsstatements.org/vocab/NoC-US/1.0/' }],
        date: [{ value: '2002-02-01' }, { value: '2003' }, { value: '199X' }, { value: 'ca. 2000' }]
      }
    end

    transient do
      asset do
        {
          id: 'b65d33d3-8c34-4e36-acf9-dab273277583',
          label: 'First Page',
          preservation_file: {
            mime_type: 'image/tiff',
            original_filename: 'e2750_wk1_body0001.tif',
            size_bytes: 1234,
            url: 'https://apotheca.library.upenn.edu/v1/assets/b65d33d3-8c34-4e36-acf9-dab273277583/preservation'
          },
          derivatives: {
            thumbnail: {
              mime_type: 'image/jpeg',
              size_bytes: 2345,
              url: 'https://apotheca.library.upenn.edu/v1/assets/b65d33d3-8c34-4e36-acf9-dab273277583/thumbnail'
            },
            access: {
              mime_type: 'image/tiff',
              size_bytes: 56_789,
              url: 'https://apotheca.library.upenn.edu/v1/assets/b65d33d3-8c34-4e36-acf9-dab273277583/access'
            }
          }
        }
      end

      preview do
        {
          mime_type: 'image/jpeg',
          size_bytes: 2345,
          url: 'https://apotheca.library.upenn.edu/v1/items/36a224db-c416-4769-9da1-28513827d179/preview'
        }
      end

      pdf do
        {
          mime_type: 'application/pdf',
          size_bytes: 5027,
          url: 'https://apotheca.library.upenn.edu/iiif/items/36a224db-c416-4769-9da1-28513827d179/pdf'
        }
      end

      iiif_manifest do
        {
          mime_type: 'application/json',
          size_bytes: 5027,
          url: 'https://apotheca.library.upenn.edu/iiif/items/36a224db-c416-4769-9da1-28513827d179/manifest'
        }
      end
    end

    assets { [asset] }

    derivatives { { preview: preview, pdf: pdf, iiif_manifest: iiif_manifest } }

    trait(:video) do
      asset do
        {
          id: '1a31877e-a413-4885-9364-40d19738b347',
          label: nil,
          preservation_file: {
            mime_type: 'video/quicktime',
            original_filename: 'icbd.mov',
            size_bytes: 597_871_141,
            url: 'https://apotheca.library.upenn.edu/v1/assets/1a31877e-a413-4885-9364-40d19738b347/preservation'
          },
          derivatives: {
            thumbnail: {
              mime_type: 'image/jpeg',
              size_bytes: 2345,
              url: 'https://apotheca.library.upenn.edu/v1/assets/1a31877e-a413-4885-9364-40d19738b347/thumbnail'
            },
            access: {
              mime_type: 'video/mp4',
              size_bytes: 329_845,
              url: 'https://apotheca.library.upenn.edu/v1/assets/1a31877e-a413-4885-9364-40d19738b347/access'
            }
          }
        }
      end

      iiif_manifest { nil }
      pdf { nil }
    end

    skip_create
    initialize_with { new(attributes) }
  end
end
