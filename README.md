# PostgreSQLAdapterExtensions

PostgreSQL Adapter Extensions for ActiveRecord.

`postgresql_adapter_extensions` is a Ruby gem that extends the `ActiveRecord::ConnectionAdapters::PostgreSQLAdapter`
to add additional sequence-related methods for managing PostgreSQL sequences in a Rails application.

[![Ruby](https://github.com/shivam091/postgresql_adapter_extensions/actions/workflows/main.yml/badge.svg)](https://github.com/shivam091/postgresql_adapter_extensions/actions/workflows/main.yml)
[![Gem Version](https://badge.fury.io/rb/postgresql_adapter_extensions.svg)](https://badge.fury.io/rb/postgresql_adapter_extensions)
[![Gem Downloads](https://img.shields.io/gem/dt/postgresql_adapter_extensions.svg)](http://rubygems.org/gems/postgresql_adapter_extensions)
[![Maintainability](https://api.codeclimate.com/v1/badges/be55ce822a1f617f6bdd/maintainability)](https://codeclimate.com/github/shivam091/postgresql_adapter_extensions/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/be55ce822a1f617f6bdd/test_coverage)](https://codeclimate.com/github/shivam091/postgresql_adapter_extensions/test_coverage)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/shivam091/postgresql_adapter_extensions/blob/main/LICENSE.md)

[Harshal V. Ladhe, Master of Computer Science.](https://shivam091.github.io)

## Introduction

This gem provides easy-to-use methods to create, alter, and drop sequences, which can be useful for handling
auto-incrementing IDs and other sequence-based logic in your database.

## Minimum Requirements

* Ruby 3.3+ ([Download Ruby](https://www.ruby-lang.org/en/downloads/branches/))
* Rails 8.0.0+ ([RubyGems - Rails Versions](https://rubygems.org/gems/rails/versions))
* ActiveRecord 8.0.0+ (comes with Rails)

## Installation

To use `postgresql_adapter_extensions` in your Rails application, add the following line to your Gemfile:

```ruby
gem "postgresql_adapter_extensions"
```

And then execute:

`$ bundle install`

Or otherwise simply install it yourself as:

`$ gem install postgresql_adapter_extensions`

## PostgreSQL Setup for Contributors

If you're contributing to this gem and need to set up PostgreSQL for local development or testing,
you can use the provided setup script. This script will help you create the necessary PostgreSQL
user and database.

### Running the Setup Script

To set up PostgreSQL, run the following script. The script will create the PostgreSQL user and database required for testing:

1. **Clone the repository** and navigate to the root directory of the gem.
2. Make sure you have PostgreSQL installed and running on your machine.
3. Run the script using the following command:

   `$ bin/setup_postgresql.sh`

4. The script will prompt you to enter the following details (if not passed as arguments):
   - PostgreSQL Database Name
   - PostgreSQL Username
   - PostgreSQL Password

   These details will be used to set up a PostgreSQL user and a database for local testing.

### What the Script Does

1. Creates a PostgreSQL user if it does not already exist.
2. Creates a PostgreSQL database if it does not already exist.
3. Grants the necessary privileges to the user for the database.

***Note: This script is only required if you're contributing to the development of the gem or testing locally. It is not required for end users of the gem.***

## Tests

The gem includes RSpec tests to verify that the sequence methods behave as expected.

### Running the Tests

To run the tests, you need to install the required dependencies first:

`$ bundle install`

Then, run the tests with:

`$ bundle exec rspec`

The tests are located in the `spec/` directory and verify the behavior of `create_sequence`,
`alter_sequence`, and `drop_sequence` methods.

## Contributing

Contributions to this project are welcomed! To contribute:

1. Fork this repository
2. Create a new branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push the changes to your branch (`git push origin my-new-feature`)
5. Create new **Pull Request**

## License

Copyright 2025 [Harshal V. LADHE](https://shivam091.github.io), Released under the [MIT License](http://opensource.org/licenses/MIT).
