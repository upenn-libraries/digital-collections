# frozen_string_literal: true

require_relative 'concerns/indexable'

describe Item do
  it_behaves_like 'indexable'

  describe '#valid?' do
    let(:item) { described_class.new(published_json: {}) }

    context 'when published_json is not present' do
      let(:item) { described_class.new(published_json: {}) }

      it 'adds expected error' do
        expect(item.valid?).to be false
        expect(item.errors.messages[:published_json]).to include 'can\'t be blank'
      end
    end

    context 'when required keys missing from published_json' do
      let(:item) do
        described_class.new(published_json: { 'id' => '1234', 'descriptive_metadata' => {} })
      end

      it 'adds expected errors' do
        expect(item.valid?).to be false
        expect(item.errors.messages[:published_json]).to include(
          'missing the following key(s): ark, first_published_at, last_published_at, assets'
        )
      end
    end
  end
end
