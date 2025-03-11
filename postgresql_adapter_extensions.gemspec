# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

lib = File.expand_path("../lib", __FILE__)
$:.unshift(lib) unless $:.include?(lib)

require "postgresql_adapter_extensions/version"

Gem::Specification.new do |spec|
  spec.name = "postgresql_adapter_extensions"
  spec.version = PostgreSQLAdapterExtensions::VERSION
  spec.authors = ["Harshal LADHE"]
  spec.email = ["harshal.ladhe.1@gmail.com"]

  spec.summary = "PostgreSQL Adapter Extensions for ActiveRecord"
  spec.description = "Provides methods to create, alter, and drop sequences in PostgreSQL through ActiveRecord."
  spec.homepage = "https://github.com/shivam091/postgresql_adapter_extensions"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.3"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/shivam091/postgresql_adapter_extensions"
  spec.metadata["changelog_uri"] = "https://github.com/shivam091/postgresql_adapter_extensions/blob/main/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://shivam091.github.io/postgresql_adapter_extensions"
  spec.metadata["bug_tracker_uri"] = "https://github.com/shivam091/postgresql_adapter_extensions/issues"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activerecord", "~> 8"
  spec.add_runtime_dependency "pg", "~> 1.5"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov", "~> 0.21", ">= 0.21.2"
  spec.add_development_dependency "byebug", "~> 11"
end
