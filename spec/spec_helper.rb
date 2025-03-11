# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

ENV["RAILS_ENV"] ||= "test"

require "simplecov"
SimpleCov.start

$:.unshift File.expand_path("../../lib", __FILE__)
require "postgresql_adapter_extensions"

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |file| require file }

RSpec.configure do |config|
  config.color = true
  config.formatter = :documentation
  config.order = :defined

  config.before(:suite) do
    ActiveRecord::Base.establish_connection(
      adapter:  "postgresql",
      host:     ENV.fetch("PG_HOST", "localhost"),
      port:     ENV.fetch("PG_PORT", 5432),
      database: ENV.fetch("PG_DATABASE", "test_db"),
      username: ENV.fetch("PG_USER", "test_user"),
      password: ENV.fetch("PG_PASSWORD", "test_password")
    )
  end

  config.after(:suite) do
    ActiveRecord::Base.connection.disconnect!
  end

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Include support classes and modules.
  config.include MigrationHelpers
end
