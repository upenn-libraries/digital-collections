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
    end

    puts 'Creating databases...'
    ActiveRecord::Tasks::DatabaseTasks.create_current
    # Migrate databases
    puts 'Migrating databases...'
    system('RAILS_ENV=development rake db:migrate')
    system('RAILS_ENV=test rake db:migrate')

    puts 'Populating development collection with sample records...'
    Rake::Task['tools:add_sample_records'].execute
  end

  desc 'Stop running containers'
  task stop: :environment do
    system('docker compose stop')
  end

  desc 'Removes containers and volumes'
  task clean: :environment do
    system('docker compose down --volumes')
  end

  desc 'Add sample records'
  task add_sample_records: :environment do
    digital_repository = DigitalRepository.new

    Settings.digital_repository.sample_records.each do |id|
      json = digital_repository.item(id, assets: true)

      # Wrap in a transaction in case adding the document to Solr fails.
      Item.transaction do
        item = Item.find_or_initialize_by(id: json['item']['id'])
        item.published_json = json['item']
        item.save!
        item.add_solr_document!
      end
    end
  end
end
