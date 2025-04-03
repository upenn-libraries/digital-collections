# frozen_string_literal: true

namespace :tools do
  # TODO: add solr tools, spin up solr collection, update desc with solr
  desc 'Initialize project, including database'
  task start: :environment do
    system('docker compose up -d')
    sleep 2 # give services some time to start up before proceeding
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
