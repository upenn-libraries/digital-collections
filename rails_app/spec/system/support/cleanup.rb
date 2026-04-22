# frozen_string_literal: true

# Clean up step after running test suite.
#
# Clobber precompiled assets after running system tests to ensure development environment dynamically generates assets.
# We also need to recompile the development javascript assets using the yarn build command.
RSpec.configure do |config|
  config.after(:suite) do
    examples = RSpec.world.filtered_examples.values.flatten
    has_no_system_tests = examples.none? { |example| example.metadata[:type] == :system }

    if has_no_system_tests
      $stdout.puts "\n🚀️️  No system test selected. Skip clobbering assets.\n"
      next
    end

    $stdout.puts "\n🔨  Clobbering assets.\n"

    start = Time.current
    begin
      require 'rake'
      Rails.application.load_tasks
      Rake::Task['assets:clobber'].invoke
    ensure
      $stdout.puts "Finished in #{(Time.current - start).round(2)} seconds"
    end

    $stdout.puts "\n  Recompiling assets.\n"

    begin
      system('yarn build')
    ensure
      $stdout.puts "Finished recompiling assets.\n"
    end
  end
end
