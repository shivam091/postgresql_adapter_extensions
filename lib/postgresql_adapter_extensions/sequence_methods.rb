# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module PostgreSQLAdapterExtensions
  ##
  # This module provides methods for managing PostgreSQL sequences, including
  # creating, altering, and dropping sequences with various customization options.
  #
  # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
  # @since 1.0.0
  #
  # @note This module is designed for PostgreSQL databases and may not be compatible with other database systems.
  #
  module SequenceMethods
    ##
    # Creates a new sequence in the PostgreSQL database with customizable options.
    #
    # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
    # @since 1.0.0
    #
    # @param name [String, Symbol] The name of the sequence to create.
    # @param options [Hash] Additional options to configure the sequence.
    # @option options [Boolean] :if_not_exists (false) Includes `IF NOT EXISTS` to avoid errors if the sequence exists.
    # @option options [String, nil] :data_type (nil) Sets the sequence's data type (e.g., `BIGINT`, `SMALLINT`).
    # @option options [Integer] :start (1) The starting value of the sequence.
    # @option options [Integer] :increment_by (1) The increment step for each sequence value.
    # @option options [Integer, nil] :minvalue (1) The minimum value the sequence can generate. Uses `NO MINVALUE` if nil.
    # @option options [Integer, nil] :maxvalue (nil) The maximum value the sequence can generate. Uses `NO MAXVALUE` if nil.
    # @option options [Integer] :cache (1) The number of sequence values to cache for performance.
    # @option options [Boolean] :cycle (false) Whether the sequence should cycle back to the start after reaching the max value.
    # @option options [String, nil] :owned_by (nil) The table and column name that owns this sequence.
    #
    # @example Create a sequence with default options
    #   create_sequence(:order_id_seq)
    #
    # @example Create a sequence starting from 1000 with an increment of 5
    #   create_sequence(:order_id_seq, start: 1000, increment_by: 5)
    #
    # @example Create a cyclic sequence with a maximum value of 5000
    #   create_sequence(:order_id_seq, cycle: true, maxvalue: 5000)
    #
    # @example Create a sequence owned by a specific table column
    #   create_sequence(:order_id_seq, owned_by: "orders.id")
    #
    # @return [void]
    #
    # @note Uses `CREATE SEQUENCE` SQL statement with PostgreSQL-specific options.
    #
    def create_sequence(name, options = {})
      options = options.reverse_merge(
        start: 1,
        increment_by: 1,
        cache: 1,
        cycle: false,
        data_type: nil,
        owned_by: nil,
        if_not_exists: false
      )

      sql = +"CREATE SEQUENCE"
      sql << " IF NOT EXISTS" if options[:if_not_exists]
      sql << " #{quote_table_name(name)}"

      sql << " AS #{options[:data_type]}" if options[:data_type]
      sql << " INCREMENT BY #{options[:increment_by]}" if options[:increment_by]
      sql << (options[:minvalue] ? " MINVALUE #{options[:minvalue]}" : " NO MINVALUE")
      sql << (options[:maxvalue] ? " MAXVALUE #{options[:maxvalue]}" : " NO MAXVALUE")
      sql << " START WITH #{options[:start]}" if options[:start]
      sql << " CACHE #{options[:cache]}" if options[:cache]
      sql << (options[:cycle] ? " CYCLE" : " NO CYCLE")
      sql << " OWNED BY #{options[:owned_by]}" if options[:owned_by]

      execute(sql).tap { reload_type_map }
    end

    # Alters an existing PostgreSQL sequence with the given options.
    #
    # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
    # @since 1.0.0
    #
    # @param name [String, Symbol] The name of the sequence to alter.
    # @param options [Hash] A hash of options to modify the sequence behavior.
    # @option options [Boolean] :if_exists Includes `IF EXISTS` to avoid errors if the sequence does not exist.
    # @option options [String, nil] :data_type Sets the sequence's data type (e.g., `BIGINT`, `SMALLINT`).
    # @option options [Integer] :increment_by Sets the increment step for the sequence.
    # @option options [Integer, nil] :minvalue Sets the minimum value for the sequence. Uses `NO MINVALUE` if nil.
    # @option options [Integer, nil] :maxvalue Sets the maximum value for the sequence. Uses `NO MAXVALUE` if nil.
    # @option options [Integer] :start Sets the starting value of the sequence.
    # @option options [Integer, nil] :restart Restarts the sequence. Uses `RESTART` if nil, `RESTART WITH value` if provided.
    # @option options [Integer] :cache Sets the number of sequence values to cache for performance.
    # @option options [Boolean] :cycle Enables (`CYCLE`) or disables (`NO CYCLE`) sequence cycling.
    # @option options [String, nil] :owned_by Associates the sequence with a table column. Uses `OWNED BY NONE` if nil.
    #
    # @example Modify the increment value of a sequence
    #   alter_sequence(:order_id_seq, increment_by: 10)
    #
    # @example Restart a sequence at a specific value
    #   alter_sequence(:order_id_seq, restart_with: 2000)
    #
    # @example Set a minimum and maximum value for a sequence
    #   alter_sequence(:order_id_seq, minvalue: 500, maxvalue: 10000)
    #
    # @example Make a sequence cycle when it reaches the maximum value
    #   alter_sequence(:order_id_seq, cycle: true)
    #
    # @example Remove the cycle behavior from a sequence
    #   alter_sequence(:order_id_seq, cycle: false)
    #
    # @example Change the owner of a sequence to a specific table column
    #   alter_sequence(:order_id_seq, owned_by: "orders.id")
    #
    # @return [void] Executes the SQL statement to alter the sequence.
    #
    # @note Uses `ALTER SEQUENCE` SQL statement with PostgreSQL-specific options.
    #
    def alter_sequence(name, options = {})
      sql = +"ALTER SEQUENCE"
      sql << " IF EXISTS" if options[:if_exists]
      sql << " #{quote_table_name(name)}"

      sql << " AS #{options[:data_type]}" if options[:data_type]
      sql << " INCREMENT BY #{options[:increment_by]}" if options[:increment_by]
      sql << (options[:minvalue] ? " MINVALUE #{options[:minvalue]}" : " NO MINVALUE")
      sql << (options[:maxvalue] ? " MAXVALUE #{options[:maxvalue]}" : " NO MAXVALUE")
      sql << " START WITH #{options[:start]}" if options[:start]
      sql << " RESTART" if options[:restart].nil? && options.key?(:restart)
      sql << " RESTART WITH #{options[:restart]}" if options[:restart]
      sql << " CACHE #{options[:cache]}" if options[:cache]
      sql << (options[:cycle] ? " CYCLE" : " NO CYCLE")
      sql << (options[:owned_by] ? " OWNED BY #{options[:owned_by]}" : " OWNED BY NONE")

      execute(sql).tap { reload_type_map }
    end

    ##
    # Drops an existing sequence from the PostgreSQL database with optional conditions.
    #
    # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
    # @since 1.0.0
    #
    # @param name [String, Symbol] The name of the sequence to drop.
    # @param options [Hash] Additional options to modify the behavior of the drop operation.
    # @option options [Boolean] :if_exists (false) Adds `IF EXISTS` to avoid errors if the sequence does not exist.
    # @option options [Symbol] :drop_behavior (`nil`) Determines whether dependent objects are also dropped.
    #   - Accepts `:cascade` to drop dependent objects.
    #   - Accepts `:restrict` to prevent dropping if dependencies exist.
    #
    # @example Drop a sequence without additional options
    #   drop_sequence(:order_id_seq)
    #
    # @example Drop a sequence if it exists
    #   drop_sequence(:order_id_seq, if_exists: true)
    #
    # @example Drop a sequence and all dependent objects
    #   drop_sequence(:order_id_seq, drop_behavior: :cascade)
    #
    # @example Drop a sequence but prevent deletion if dependencies exist
    #   drop_sequence(:order_id_seq, drop_behavior: :restrict)
    #
    # @return [void]
    #
    # @note Uses `DROP SEQUENCE` SQL statement with PostgreSQL-specific options.
    #
    def drop_sequence(name, options = {})
      options = options.reverse_merge(
        if_exists: false,
        drop_behavior: :restrict,
      )

      sql = +"DROP SEQUENCE"
      sql << " IF EXISTS" if options[:if_exists]
      sql << " #{quote_table_name(name)}"
      sql << " #{options[:drop_behavior].to_s.upcase}" if options[:drop_behavior].in?([:cascade, :restrict])

      execute(sql).tap { reload_type_map }
    end
  end
end
