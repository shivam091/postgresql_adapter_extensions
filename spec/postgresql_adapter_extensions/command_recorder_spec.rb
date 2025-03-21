# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/postgresql_adapter_extensions/command_recorder_spec.rb

require "spec_helper"

RSpec.describe PostgreSQLAdapterExtensions::CommandRecorder do
  let(:recorder) { ActiveRecord::Migration::CommandRecorder.new }

  before { recorder.extend(described_class) }

  describe "#create_sequence" do
    it "records create_sequence command" do
      recorder.create_sequence("test_seq", start: 1000)

      expect(recorder.commands).to include([:create_sequence, ["test_seq", {start: 1000}], nil])
    end

    it "records create_sequence with multiple options" do
      recorder.create_sequence("test_seq", start: 1000, increment_by: 2, minvalue: 10)

      expect(recorder.commands).to include(
        [:create_sequence, ["test_seq", { start: 1000, increment_by: 2, minvalue: 10 }], nil]
      )
    end
  end

  describe "#alter_sequence" do
    it "records alter_sequence command" do
      recorder.alter_sequence("test_seq", increment_by: 2)

      expect(recorder.commands).to include([:alter_sequence, ["test_seq", {increment_by: 2}], nil])
    end

    it "records alter_sequence with multiple options" do
      recorder.alter_sequence("test_seq", start: 500, increment_by: 5, minvalue: 50)

      expect(recorder.commands).to include(
        [:alter_sequence, ["test_seq", { start: 500, increment_by: 5, minvalue: 50 }], nil]
      )
    end
  end

  describe "#drop_sequence" do
    it "records drop_sequence command" do
      recorder.drop_sequence("test_seq")

      expect(recorder.commands).to include([:drop_sequence, ["test_seq"], nil])
    end

    it "records drop_sequence with if_exists option" do
      recorder.drop_sequence("test_seq", if_exists: true)

      expect(recorder.commands).to include([:drop_sequence, ["test_seq", { if_exists: true }], nil])
    end
  end

  describe "#invert_create_sequence" do
    it "returns drop_sequence as inverse of create_sequence" do
      expect(recorder.send(:invert_create_sequence, ["test_seq"])).to eq([:drop_sequence, ["test_seq"]])
    end
  end

  describe "#invert_alter_sequence" do
    it "raises IrreversibleMigration for alter_sequence" do
      expect {
        recorder.send(:invert_alter_sequence, ["test_seq"])
      }.to raise_error(ActiveRecord::IrreversibleMigration)
    end
  end

  describe "#invert_drop_sequence" do
    it "raises IrreversibleMigration for drop_sequence" do
      expect {
        recorder.send(:invert_drop_sequence, ["test_seq"])
      }.to raise_error(ActiveRecord::IrreversibleMigration)
    end
  end

  describe "Ensuring correct behavior of CommandRecorder" do
    it "does not record duplicate commands" do
      recorder.create_sequence("test_seq")
      recorder.create_sequence("test_seq")
      expect(recorder.commands.count { |cmd| cmd.first == :create_sequence }).to eq(2)
    end

    it "has no commands initially" do
      expect(recorder.commands).to be_empty
    end
  end
end
