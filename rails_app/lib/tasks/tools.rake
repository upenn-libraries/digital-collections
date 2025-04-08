# frozen_string_literal: true

namespace :tools do
  desc 'Initialize project, including database'
  task start: :environment do
    system('docker compose up -d')
    puts 'Waiting for Solr to be available...'
    sleep 1 until SolrTools.solr_available?
    if SolrTools.configset_exists? 'digital_collections'
      puts 'Configset is already in place. If the configset has changes, use tools:clean then tools:start to rebuild.'
    else
      puts 'Uploading configset from /solr...'
      system('docker compose exec solrcloud solr zk upconfig -d /opt/solr/configsets/dcoll -n digital_collections')
    end
    %w[digital-collections-development digital-collections-test].each do |collection|
      next if SolrTools.collection_exists? collection

      puts "Creating #{collection} collection..."
      SolrTools.create_collection collection, 'digital_collections'
      next unless collection == 'digital-collections-development'

      sample_records_path = Rails.root.join 'solr/data/dcoll-solr-samples.jsonl'
      puts "Populating development collection with sample records from #{sample_records_path}..."
      SolrTools.load_data collection, sample_records_path
    end
    puts 'Creating databases...'
    ActiveRecord::Tasks::DatabaseTasks.create_current
    # Migrate databases
    puts 'Migrating databases...'
    system('RAILS_ENV=development rake db:migrate')
    system('RAILS_ENV=test rake db:migrate')
  end

  desc 'Stop running containers'
  task stop: :environment do
    system('docker compose stop')
  end

  desc 'Removes containers and volumes'
  task clean: :environment do
    system('docker compose down --volumes')
  end
end
