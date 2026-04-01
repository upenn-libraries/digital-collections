# frozen_string_literal: true

# Cuprite config based on https://evilmartians.com/chronicles/system-of-a-test-setting-up-end-to-end-rails-testing

# First, load Cuprite Capybara integration
require 'capybara/cuprite'

# Register our driver to be able to use it later with #driven_by method.
# NOTE: The name :cuprite is already registered by Rails. See https://github.com/rubycdp/cuprite/issues/180
Capybara.register_driver(:better_cuprite) do |app|
  Capybara::Cuprite::Driver.new(
    app,
    **{
      # See ferrum docs for config options: https://github.com/rubycdp/ferrum
      flatten: false,
      inspector: !ENV['CI'], # Enable debugging capabilities
      js_errors: true, # Re-raise js errors in Ruby
      timeout: 30, # How long to wait for a response from browser before raising a pending connection error
      window_size: [1600, 1200],
      ws_url: ENV.fetch('CHROME_URL', 'ws://localhost:3333')
    }
  )
end

# Configure Capybara to use :better_cuprite driver by default
Capybara.default_driver = Capybara.javascript_driver = :better_cuprite

module CupriteHelpers
  # Drop #pause anywhere in a test to stop the execution.
  # Useful when you want to checkout the contents of a web page in the middle of a test
  # running in a headful mode.
  def pause
    page.driver.pause
  end

  def debug(binding = nil)
    $stdout.puts '🔎 Open Chrome inspector at http://digitalcollections-dev.library.upenn.int/chrome/debugger/?token=xxx'
    return binding.break if binding

    page.driver.pause
  end
end

RSpec.configure do |config|
  config.include CupriteHelpers, type: :system
end
