# frozen_string_literal: true

describe EDTFIndexer do
  let(:indexer) { EDTFIndexer.new(value) }

  describe '.humanize' do
    subject(:date) { indexer.humanize }

    context 'with a known decade' do
      let(:value) { '192X' }

      it { is_expected.to eql '1920s' }
    end

    context 'with a known century' do
      let(:value) { '19XX' }

      it { is_expected.to eql '1900s' }
    end
  end

  describe '.years' do
    subject(:years) { indexer.years }

    context 'with a single year, month and day' do
      let(:value) { '1985-04-12' }

      it { is_expected.to contain_exactly('1985') }
    end

    context 'with a single year and month' do
      let(:value) { '1985-04' }

      it { is_expected.to contain_exactly('1985') }
    end

    context 'with a single year' do
      let(:value) { '1985' }

      it { is_expected.to contain_exactly(value) }
    end


    context 'with a known decade' do
      let(:value) { '192X' }

      it { is_expected.to match_array((1920..1929).map(&:to_s)) }
    end

    context 'with a known century' do
      let(:value) { '19XX' }

      it { is_expected.to match_array((1900..1999).map(&:to_s)) }
    end
  end
end