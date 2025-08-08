# frozen_string_literal: true

require 'active_support/number_helper'

describe DC::AssetPresenter do
  let(:presenter) { described_class.new(asset: asset) }
  let(:asset) { build(:item_indexer, :video).data[:assets].first }

  describe '#filename' do
    subject { presenter.filename }

    it { is_expected.to eq asset[:preservation_file][:original_filename] }
  end

  describe '#access_derivative?' do
    subject { presenter.access_derivative? }

    context 'with an access derivative' do
      it { is_expected.to be true }
    end

    context 'without an access derivative' do
      let(:asset) { { derivatives: {} } }

      it { is_expected.to be false }
    end
  end

  describe '#access_file_url' do
    subject { presenter.access_file_url }

    it { is_expected.to eq asset[:derivatives][:access][:url] }
  end

  describe '#access_file_extension' do
    subject { presenter.access_file_extension }

    it { is_expected.to eq '.mp4' }
  end

  describe '#access_file_size' do
    it 'returns the access derivative file size' do
      file_size = ActiveSupport::NumberHelper.number_to_human_size(asset[:derivatives][:access][:size_bytes],
                                                                   prefix: :si)
      expect(presenter.access_file_size).to eq file_size
    end
  end

  describe '#preservation_file_url' do
    subject { presenter.preservation_file_url }

    it { is_expected.to eq asset[:preservation_file][:url] }
  end

  describe '#preservation_file_extension' do
    subject { presenter.preservation_file_extension }

    it { is_expected.to eq '.mov' }
  end

  describe '#preservation_file_size' do
    it 'returns the preservation file size' do
      file_size = ActiveSupport::NumberHelper.number_to_human_size(asset[:preservation_file][:size_bytes], prefix: :si)
      expect(presenter.preservation_file_size).to eq file_size
    end
  end
end
