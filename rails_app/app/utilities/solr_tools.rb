# frozen_string_literal: true

# Wrappers for Solr API calls used to set up and maintain Solr collections for development and test environments
class SolrTools
  class CommandError < StandardError; end

  # @param collection_name [Object]
  # @return [Boolean]
  def self.collection_exists?(collection_name)
    list = connection.get('/solr/admin/collections', action: 'LIST')
    collections = JSON.parse(list.body)['collections']
    collections.include? collection_name
  end

  # @param configset_name [String]
  # @return [Boolean]
  def self.configset_exists?(configset_name)
    list = connection.get('/solr/admin/configs', action: 'LIST')
    configsets = JSON.parse(list.body)['configSets']
    configsets.include? configset_name
  end

  # @param collection_name [String]
  # @param configset_name [String]
  # @raise [CommandError]
  def self.create_collection(collection_name, configset_name)
    response = connection.get('/solr/admin/collections',
                              action: 'CREATE', name: collection_name,
                              numShards: '1', 'collection.configName': configset_name)
    raise CommandError, "Solr command failed with response: #{response.body}" unless response.success?
  end

  # @param collection_name [String]
  # @param documents_file_path [String] path where JSONL file is located
  # @raise [CommandError]
  def self.load_data(collection_name, documents_file_path)
    body = "{ \"add\": [#{File.readlines(documents_file_path).join(',')}] }"
    response = connection.post("/solr/#{collection_name}/update") do |req|
      req.params = { commit: 'true' }
      req.headers['Content-Type'] = 'application/json'
      req.body = body
    end
    raise CommandError, "Solr command failed with response: #{response.body}" unless response.success?
  end

  # @param collection_name [String] collection to clear - defaults to collection defined in Settings.solr.url
  # @raise [CommandError]
  def self.clear_collection(collection_name = current_collection_name)
    body = "{'delete': {'query': '*:*'}}"
    response = connection.post("/solr/#{collection_name}/update") do |req|
      req.params = { commit: 'true' }
      req.headers['Content-Type'] = 'application/json'
      req.body = body
    end
    raise CommandError, "Solr command failed with response: #{response.body}" unless response.success?
  end

  # Returns name of current collection configured in the Solr URL.
  # @return [String]
  def self.current_collection_name
    uri = URI.parse(Settings.solr.url)
    uri.path.delete_prefix('/solr/')
  end

  # Check if Solr is up by checking cluster state API
  # @return [Boolean]
  def self.solr_available?
    connection.get('solr/admin/collections', action: 'CLUSTERSTATUS').success?
  rescue StandardError => _e
    false
  end

  # @param collection_name [String] collection to check - defaults to collection defined in Settings.solr.url
  # @return [Boolean]
  def self.collection_empty?(collection_name = current_collection_name)
    resp = connection.get("solr/#{collection_name}/select", params: { q: '*:*' }, rows: 0)
    JSON.parse(resp.body)['response']['numFound'].zero?
  end

  # @return [Faraday::Connection]
  def self.connection
    uri = URI.parse(Settings.solr.url) # Parsing out connection details from URL.

    Faraday.new("#{uri.scheme}://#{uri.host}:#{uri.port}")
  end
end
