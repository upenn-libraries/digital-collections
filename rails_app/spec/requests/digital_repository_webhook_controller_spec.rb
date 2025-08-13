# frozen_string_literal: true

describe 'Digital Repository Webhook requests' do
  describe 'POST #listen' do
    let(:headers) do
      { 'Content-Type' => 'application/json',
        'Authorization' => "Token token=#{Settings.digital_repository.webhook_token}" }
    end
    let(:params) { { event: 'publish', data: { item: item } } }
    let(:id) { item[:id] }
    let(:item) { build(:item_hash) }

    before { post listen_path, params: params.to_json, headers: headers }

    context 'with invalid token' do
      let(:headers) { {} }

      it 'returns 401' do
        expect(response).to have_http_status :unauthorized
      end
    end

    context 'when publishing a new item' do
      it 'returns 200' do
        expect(response).to have_http_status :success
      end

      it 'returns expected response body' do
        expect(response.parsed_body).to eql({ 'status' => 'success', 'data' => { 'item' => solr_document_url(id) } })
      end

      it 'adds document to Solr' do
        solr = RSolr.connect(url: Settings.solr.url)
        response = solr.get('select', params: { q: "id:\"#{id}\"" })
        expect(response['response']['numFound']).to be 1
      end

      it 'adds a database record' do
        expect(Item.find_by(id: id)).to be_present
      end
    end

    context 'when publishing an existing item' do
      let(:updated_item) { build(:item_hash, descriptive_metadata: { title: [{ value: 'New Title' }] }) }

      before do
        post listen_path, params: { event: 'publish', data: { item: updated_item } }.to_json, headers: headers
      end

      it 'returns 200' do
        expect(response).to have_http_status :success
      end

      it 'returns expected response body' do
        expect(response.parsed_body).to eql({ 'status' => 'success', 'data' => { 'item' => solr_document_url(id) } })
      end

      it 'updates record in Solr' do
        solr = RSolr.connect(url: Settings.solr.url)
        solr_doc = solr.get('select', params: { q: "id:\"#{id}\"" })['response']['docs'].first
        expect(solr_doc).to include('title_tesim' => ['New Title'])
      end

      it 'updates record in database' do
        expect(Item.find_by(id: id).published_json).to match(**updated_item.deep_stringify_keys)
      end
    end

    context 'when unpublishing an item' do
      before do
        post listen_path, params: { event: 'unpublish', data: { item: item } }.to_json, headers: headers
      end

      it 'returns 200' do
        expect(response).to have_http_status :ok
      end

      it 'returns expected response body' do
        expect(response.parsed_body).to eql({ 'status' => 'success' })
      end

      it 'deletes record from Solr' do
        solr = RSolr.connect(url: Settings.solr.url)
        response = solr.get('select', params: { q: "id:\"#{id}\"" })
        expect(response['response']['numFound']).to be 0
      end

      it 'deletes record from database' do
        expect(Item.find_by(id: id)).to be_nil
      end
    end

    context 'when request event is invalid' do
      let(:params) { { event: 'update', data: { item: item } } }

      it 'returns 400' do
        expect(response).to have_http_status :bad_request
      end

      it 'returns expected response body' do
        expect(response.parsed_body).to eql({ 'status' => 'error', 'message' => 'Invalid event: update' })
      end
    end

    context 'when unpublishing an unknown item' do
      let(:params) { { event: 'unpublish', data: { item: { id: '1234-1234' } } } }

      it 'returns 404' do
        expect(response).to have_http_status :not_found
      end

      it 'returns expected response body' do
        expect(response.parsed_body).to eql({ 'status' => 'error', 'message' => 'Resource not found.' })
      end
    end
  end
end
