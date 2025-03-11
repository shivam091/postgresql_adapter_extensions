# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/postgresql_adapter_extensions/sequence_methods_spec.rb

require "spec_helper"

RSpec.describe PostgreSQLAdapterExtensions::SequenceMethods do
  before do
    connection.drop_sequence(:order_id_seq, if_exists: true, drop_behavior: :cascade)
    connection.drop_table(:orders, if_exists: true)
  end

  describe "#create_sequence" do
    context "when creating a sequence without options" do
      it "creates a sequence successfully with default values" do
        connection.create_sequence(:order_id_seq)

        expect(connection.select_value("SELECT nextval('order_id_seq')")).to eq(1)
        expect(connection.select_value("SELECT nextval('order_id_seq')")).to eq(2)
      end
    end

    context "when creating a sequence with 'start' option" do
      it "creates a sequence with a start value" do
        connection.create_sequence(:order_id_seq, start: 500)

        expect(connection.select_value("SELECT nextval('order_id_seq')")).to eq(500)
        expect(connection.select_value("SELECT nextval('order_id_seq')")).to eq(501)
      end
    end

    context "when creating a sequence with 'increment_by' option" do
      it "creates a sequence with a incremental value" do
        connection.create_sequence(:order_id_seq, start: 100, increment_by: 5)

        expect(connection.select_value("SELECT nextval('order_id_seq')")).to eq(100)
        expect(connection.select_value("SELECT nextval('order_id_seq')")).to eq(105)
      end
    end

    context "when creating a sequence with 'minvalue' option" do
      it "creates a sequence with a minimum value" do
        connection.create_sequence(:order_id_seq, start: 100, minvalue: 10)

        minvalue = connection.select_value(<<-SQL)
          SELECT min_value FROM pg_sequences
          WHERE schemaname = 'public' AND sequencename = 'order_id_seq'
        SQL

        expect(minvalue).to eq(10)
      end
    end

    context "when creating a sequence with 'maxvalue' option" do
      it "creates a sequence with a maximum value" do
        connection.create_sequence(:order_id_seq, maxvalue: 5000)

        maxvalue = connection.select_value(<<-SQL)
          SELECT max_value FROM pg_sequences
          WHERE schemaname = 'public' AND sequencename = 'order_id_seq'
        SQL

        expect(maxvalue).to eq(5000)
      end
    end

    context "when creating a sequence with 'cache' option" do
      it "creates a sequence with cache size" do
        connection.create_sequence(:order_id_seq, cache: 10)

        cache_size = connection.select_value(<<-SQL)
          SELECT cache_size FROM pg_sequences
          WHERE schemaname = 'public' AND sequencename = 'order_id_seq'
        SQL

        expect(cache_size).to eq(10)
      end
    end

    context "when creating a sequence with 'cycle' option" do
      context "when using 'cycle: true'" do
        it "creates a sequence with cycle enabled" do
          connection.create_sequence(:order_id_seq, cycle: true)

          cycle_flag = connection.select_value(<<-SQL)
            SELECT cycle FROM pg_sequences
            WHERE schemaname = 'public' AND sequencename = 'order_id_seq'
          SQL

          expect(cycle_flag).to be_truthy
        end
      end

      context "when using 'cycle: false'" do
        it "creates a sequence with cycle disabled" do
          connection.create_sequence(:order_id_seq, cycle: false)

          cycle_flag = connection.select_value(<<-SQL)
            SELECT cycle FROM pg_sequences
            WHERE schemaname = 'public' AND sequencename = 'order_id_seq'
          SQL

          expect(cycle_flag).to be_falsy
        end
      end
    end

    context "when creating a sequence with 'if_not_exists' option" do
      it "creates a sequence if not exists" do
        connection.create_sequence(:order_id_seq, start: 1000, if_not_exists: true)
        connection.create_sequence(:order_id_seq, start: 2000, if_not_exists: true) # Should not change existing sequence

        expect(connection.select_value("SELECT nextval('order_id_seq')")).to eq(1000)
      end
    end

    context "when creating a sequence with 'data_type' option" do
      it "creates a sequence with a specific data type" do
        connection.create_sequence(:order_id_seq, data_type: "BIGINT")

        data_type = connection.select_value(<<-SQL)
          SELECT data_type FROM information_schema.sequences
          WHERE sequence_name = 'order_id_seq'
        SQL

        expect(data_type).to eq("bigint")
      end
    end

    context "when creating a sequence with 'owned_by' option" do
      it "creates a sequence owned by a table column" do
        connection.create_table(:orders)
        connection.create_sequence(:order_id_seq, owned_by: "orders.id")

        owned_by = connection.select_value(<<-SQL)
          SELECT pg_get_serial_sequence('orders', 'id')
        SQL

        expect(owned_by).to eq("public.orders_id_seq")
      end
    end
  end

  describe "#drop_sequence" do
    before { connection.create_sequence(:order_id_seq, start: 1000) }

    context "when dropping a sequence without options" do
      it "drops the sequence successfully with default values" do
        connection.drop_sequence(:order_id_seq)

        expect {
          connection.select_value("SELECT last_value FROM order_id_seq")
        }.to raise_error(ActiveRecord::StatementInvalid)
      end
    end

    context "when dropping a sequence with 'if_exists' option" do
      it "does not raise an error if the sequence does not exist" do
        connection.drop_sequence(:order_id_seq) # Dropping it first

        expect {
          connection.drop_sequence(:order_id_seq, if_exists: true)
        }.not_to raise_error
      end

      it "drops the sequence if it exists" do
        expect {
          connection.drop_sequence(:order_id_seq, if_exists: false)
        }.to change {
          connection.select_value("SELECT COUNT(*) FROM pg_class WHERE relname = 'order_id_seq'")
        }.from(1).to(0)
      end
    end

    context "when dropping a sequence with 'drop_behavior' option" do
      context "when using 'drop_behavior: :cascade'" do
        it "drops the sequence and dependent objects" do
          connection.create_table(:orders)
          connection.drop_sequence(:order_id_seq, drop_behavior: :cascade)

          expect {
            connection.select_value("SELECT last_value FROM order_id_seq")
          }.to raise_error(ActiveRecord::StatementInvalid)
        end
      end

      context "when using 'drop_behavior: :restrict'" do
        it "prevents dropping the sequence if there are dependencies" do
          connection.create_table(:orders) do |t|
            t.integer :order_number, default: -> { "nextval('order_id_seq')" }
          end

          expect {
            connection.drop_sequence(:order_id_seq, drop_behavior: :restrict)
          }.to raise_error(ActiveRecord::StatementInvalid)
        end
      end
    end

    context "when using both 'if_exists' and 'drop_behavior' options" do
      it "drops the sequence if it exists and applies drop_behavior" do
        connection.drop_sequence(:order_id_seq, if_exists: true, drop_behavior: :cascade)

        expect {
          connection.select_value("SELECT last_value FROM order_id_seq")
        }.to raise_error(ActiveRecord::StatementInvalid)
      end
    end

    context "when dropping a non-existent sequence without 'if_exists'" do
      it "raises an error" do
        connection.drop_sequence(:order_id_seq) # Dropping first

        expect {
          connection.drop_sequence(:order_id_seq)
        }.to raise_error(ActiveRecord::StatementInvalid)
      end
    end
  end

  describe "edge cases" do
    it "handles dropping and recreating the same sequence" do
      connection.create_sequence(:order_id_seq, start: 500)
      connection.drop_sequence(:order_id_seq, if_exists: true)
      connection.create_sequence(:order_id_seq, start: 1000)

      expect(connection.select_value("SELECT nextval('order_id_seq')")).to eq(1000)
    end

    it "ensures sequence starts at the correct value after dropping and recreating" do
      connection.create_sequence(:order_id_seq, start: 100)
      connection.select_value("SELECT nextval('order_id_seq')") # Move to 101

      connection.drop_sequence(:order_id_seq, if_exists: true)
      connection.create_sequence(:order_id_seq, start: 200)

      expect(connection.select_value("SELECT nextval('order_id_seq')")).to eq(200)
    end

    it "raises an error if an invalid sequence name is used" do
      expect {
        connection.create_sequence("invalid-sequence-name!")
      }.to raise_error(ActiveRecord::StatementInvalid)
    end

    it "ensures cache value is properly set" do
      connection.create_sequence(:order_id_seq, start: 1000, increment_by: 5)

      cache_value = connection.select_value("SELECT cache_size FROM pg_sequences WHERE schemaname = 'public' AND sequencename = 'order_id_seq'")

      expect(cache_value).to eq(1) # Default cache value
    end
  end
end
