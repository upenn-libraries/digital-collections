# frozen_string_literal: true

shared_examples_for 'indexable' do
  let(:object) { described_class.new(id: id) }
  let(:id) { 'bf814045-9e74-4866-af3c-be1ca4bcf380' }

  let(:solr) { RSolr.connect(url: Settings.solr.url) }
  let(:solr_document) { { id: id } }
  let(:solr_response) { solr.get('select', params: { q: "id:\"#{id}\"" }) }

  before do
    allow(object).to receive(:to_solr).and_return(solr_document)
  end

  describe '#add_to_solr!' do
    before { object.add_to_solr! }

    it 'adds document to Solr' do
      expect(solr_response['response']['numFound']).to be 1
    end
  end

  describe '#remove_from_solr!' do
    before { object.add_to_solr! }

    it 'removes solr document' do
      object.remove_from_solr!
      expect(solr_response['response']['numFound']).to be 0
    end
  end
end
