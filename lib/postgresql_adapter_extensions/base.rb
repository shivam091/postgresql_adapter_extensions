# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

require "active_record"
require "active_record/connection_adapters/postgresql_adapter"

module PostgreSQLAdapterExtensions

  # This is the base class for custom errors in the +PostgreSQLAdapterExtensions+ module.
  #
  # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
  # @since 0.1.0
  class BaseError < StandardError; end
end
