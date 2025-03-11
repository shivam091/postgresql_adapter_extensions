# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module PostgreSQLAdapterExtensions
  module SequenceMethods
    ##
    # Creates a new sequence in the PostgreSQL database with customizable options.
    #
    # @param name [String, Symbol] The name of the sequence to create.
    # @param options [Hash] Additional options to configure the sequence.
    # @option options [Integer] :start (1) The starting value of the sequence.
    # @option options [Integer] :increment_by (1) The increment step for each sequence value.
    # @option options [Integer, nil] :minvalue (1) The minimum value the sequence can generate.
    #   - If `nil`, `NO MINVALUE` is used in the query.
    # @option options [Integer, nil] :maxvalue (nil) The maximum value the sequence can generate.
    #   - If `nil`, `NO MAXVALUE` is used in the query.
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
    
    ##
    # Drops an existing sequence from the PostgreSQL database with optional conditions.
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
