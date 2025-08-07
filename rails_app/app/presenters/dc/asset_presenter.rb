# frozen_string_literal: true

module DC
  # Encapsulate display logic for assets
  class AssetPresenter
    attr_reader :asset

    # @param asset [Hash]
    def initialize(asset:)
      @asset = asset.deep_stringify_keys
    end

    # @return [String, Nil]
    def filename
      preservation_file['original_filename']
    end

    # Returns true if asset has an access derivative
    # @return [Boolean]
    def access_derivative?
      access_derivative.present?
    end

    # @return [String, Nil]
    def access_file_url
      access_derivative['url']
    end

    # @return [String, Nil]
    def access_file_extension
      mime_extension(access_derivative['mime_type'])
    end

    # @return [String, Nil]
    def access_file_size
      human_readable_size(access_derivative['size_bytes'])
    end

    # @return [String, Nil]
    def preservation_file_url
      preservation_file['url']
    end

    # @return [String, Nil]
    def preservation_file_extension
      Pathname.new(filename).extname.presence || mime_extension(preservation_file['mime_type'])
    end

    # @return [String, Nil]
    def preservation_file_size
      human_readable_size(preservation_file['size_bytes'])
    end

    private

    def access_derivative
      asset.dig('derivatives', 'access')
    end

    def preservation_file
      asset['preservation_file']
    end

    # @param bytes [String]
    # @return [String, Nil]
    def human_readable_size(bytes)
      return unless bytes

      ActiveSupport::NumberHelper.number_to_human_size(bytes, prefix: :si)
    end

    # @param mime_type [String]
    # @return [String]
    def mime_extension(mime_type)
      return unless mime_type

      Rack::Mime::MIME_TYPES.invert[mime_type]
    end
  end
end
