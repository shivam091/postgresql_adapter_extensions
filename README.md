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

## Usage

### create_sequence

The `create_sequence` method allows you to create a new sequence in your PostgreSQL database with customizable options. A sequence is typically used to auto-generate unique values for primary keys or other incrementing columns.

```ruby
create_sequence(name, options = {})
```

**Create a sequence with default options:**

 ```ruby
 create_sequence(:order_id_seq)
 ```

**Create a sequence starting from 1000 with an increment of 5:**

 ```ruby
 create_sequence(:order_id_seq, start: 1000, increment_by: 5)
 ```

**Create a cyclic sequence with a maximum value of 5000:**

 ```ruby
 create_sequence(:order_id_seq, cycle: true, maxvalue: 5000)
 ```

**Create a sequence owned by a specific table and column:**

 ```ruby
 create_sequence(:order_id_seq, owned_by: "orders.id")
 ```

### drop_sequence

The `drop_sequence` method allows you to drop an existing sequence from your PostgreSQL database, with options to control its behavior.

```ruby
drop_sequence(name, options = {})
```

**Drop a sequence without additional options:**

 ```ruby
drop_sequence(:order_id_seq)
```

**Drop a sequence if it exists:**

```ruby
drop_sequence(:order_id_seq, if_exists: true)
```

**Drop a sequence and all dependent objects:**

```ruby
drop_sequence(:order_id_seq, drop_behavior: :cascade)
```

**Drop a sequence but prevent deletion if dependencies exist:**

```ruby
drop_sequence(:order_id_seq, drop_behavior: :restrict)
```

## PostgreSQL Setup for Contributors

If you're contributing to this gem and need to set up PostgreSQL for local development or testing,
you can use the provided setup script. This script will help you create the necessary PostgreSQL
user and database for testing.

### Running the Setup Script

1. **Clone the repository** and navigate to the root directory of the gem.
2. Make sure you have PostgreSQL installed and running on your machine.
3. Run the script using the following command:

   `$ ./bin/setup_postgresql.sh`

   By default, the script will use the following values unless environment variables are set:

   1. Database Name: `rails_test`
   2. Username: `rails`
   3. Password: `password`

4. If you want to override these defaults, set the environment variables before running the script:

   `$ POSTGRES_DB=rails_test POSTGRES_USER=rails POSTGRES_PASSWORD=password ./bin/setup_postgresql.sh`

5. The script will:

   - Check if the specified PostgreSQL user exists, creating it if necessary.
   - Check if the specified database exists, creating it if necessary.
   - Grant the required privileges to the user for the database.

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
