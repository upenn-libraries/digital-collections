# frozen_string_literal: true

require_relative 'concerns/indexable'

describe Item do
  it_behaves_like 'indexable'

  describe '#valid?' do
    context 'when published_json is not present' do
      let(:item) { described_class.new(published_json: {}) }

      it 'adds correct error' do
        expect(item.valid?).to be false
        expect(item.errors.messages[:published_json]).to include 'can\'t be blank'
      end
    end
  end
end
