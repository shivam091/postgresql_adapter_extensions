# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

require "active_record"
require "active_record/connection_adapters/postgresql_adapter"

require "postgresql_adapter_extensions/command_recorder"
require "postgresql_adapter_extensions/sequence_methods"

module PostgreSQLAdapterExtensions
  ##
  # This is the base class for custom errors in the +PostgreSQLAdapterExtensions+ module.
  #
  # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
  # @since 0.1.0
  #
  class BaseError < StandardError; end

  if defined?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
    ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.include(SequenceMethods)
  end

  if defined?(ActiveRecord::Migration::CommandRecorder)
    ActiveRecord::Migration::CommandRecorder.include(CommandRecorder)
  end
end
