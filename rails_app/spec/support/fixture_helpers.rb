# frozen_string_literal: true

module FixtureHelpers
  # @param filename [String]
  # @param directory [Nil, String]
  # @return [String]
  def json_fixture(filename, directory = nil)
    filename = "#{filename}.json" unless filename.ends_with?('.json')
    dirs = ['json', directory.to_s, filename].compact_blank
    File.read(File.join(fixture_paths, dirs))
  end

  # @param filename [String]
  # @param directory [String]
  # @return [Hash]
  def item_resource_fixture(filename, directory = 'digital_repository/api/resource/items/v1')
    JSON.parse(json_fixture(filename, directory))['data']['item']
  end
end
