# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module PostgreSQLAdapterExtensions
  ##
  # Module that extends ActiveRecord's CommandRecorder to handle sequence-related commands.
  #
  # This module is designed to work with reversible migrations in ActiveRecord, specifically to manage PostgreSQL sequence operations.
  # The methods capture forward migration commands for sequences and generate their inverse using simple metaprogramming.
  #
  # @example
  #   class AddSomeSequence < ActiveRecord::Migration[6.0]
  #     def change
  #       create_sequence :some_sequence
  #     end
  #   end
  #
  # This will create a sequence, and during rollback, it will drop the sequence.
  #
  # @see ActiveRecord::Migration::CommandRecorder
  #
  # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
  # @since 1.0.0
  #
  module CommandRecorder
    ##
    # Records the creation of a PostgreSQL sequence during a migration.
    #
    # This method is invoked when creating a sequence in the database. The corresponding
    # inverse operation will be to drop the sequence during rollback.
    #
    # @param args [Array] Arguments required to create the sequence (usually the sequence name).
    # @param block [Proc] An optional block passed to the command.
    # @return [void]
    #
    # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
    # @since 1.0.0
    #
    def create_sequence(*args, &block)
      record(:create_sequence, args, &block)
    end

    ##
    # Records the alteration of a PostgreSQL sequence during a migration.
    #
    # This method is invoked when altering a sequence in the database.
    # The corresponding inverse operation is not possible, so it will raise an error during rollback.
    #
    # @param args [Array] Arguments required to alter the sequence.
    # @param block [Proc] An optional block passed to the command.
    # @raise [ActiveRecord::IrreversibleMigration] When attempting to rollback an altered sequence.
    # @return [void]
    #
    # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
    # @since 1.0.0
    #
    def alter_sequence(*args, &block)
      record(:alter_sequence, args, &block)
    end

    ##
    # Records the dropping of a PostgreSQL sequence during a migration.
    #
    # This method is invoked when dropping a sequence from the database.
    # The corresponding inverse operation is not possible, so it will raise an error during rollback.
    #
    # @param args [Array] Arguments required to drop the sequence (usually the sequence name).
    # @param block [Proc] An optional block passed to the command.
    # @raise [ActiveRecord::IrreversibleMigration] When attempting to rollback a dropped sequence.
    # @return [void]
    #
    # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
    # @since 1.0.0
    #
    def drop_sequence(*args, &block)
      record(:drop_sequence, args, &block)
    end

    private

    ##
    # Generates the inverse command for creating a sequence, which is to drop the sequence.
    #
    # @param args [Array] Arguments passed to the create_sequence method (sequence name).
    # @return [Array] An array with the inverse command `:drop_sequence` and its arguments.
    #
    # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
    # @since 1.0.0
    #
    def invert_create_sequence(args)
      [:drop_sequence, args]
    end

    ##
    # Generates the inverse command for altering a sequence, which is not possible.
    #
    # @param args [Array] Arguments passed to the alter_sequence method.
    # @raise [ActiveRecord::IrreversibleMigration] This operation cannot be reversed.
    #
    # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
    # @since 1.0.0
    #
    def invert_alter_sequence(args)
      raise ActiveRecord::IrreversibleMigration, "Alter sequence is irreversible."
    end

    ##
    # Generates the inverse command for dropping a sequence, which is not possible.
    #
    # @param args [Array] Arguments passed to the drop_sequence method (sequence name).
    # @raise [ActiveRecord::IrreversibleMigration] This operation cannot be reversed.
    #
    # @author {Harshal V. Ladhe}[https://shivam091.github.io/]
    # @since 1.0.0
    #
    def invert_drop_sequence(args)
      raise ActiveRecord::IrreversibleMigration, "Drop sequence is irreversible."
    end
  end
end
