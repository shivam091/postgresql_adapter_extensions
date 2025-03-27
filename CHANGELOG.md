## [1.2.0](https://github.com/shivam091/postgresql_adapter_extensions/compare/v1.1.0...v1.2.0) - 2025-03-27

### What's new

#### PostgreSQLAdapterExtensions::SequenceMethods
- Added `rename_sequence` method to rename a PostgreSQL sequences with optional IF EXISTS.

#### PostgreSQLAdapterExtensions::CommandRecorder
- Added `rename_sequence` method to record sequence rename in migrations.
- Implemented `invert_rename_sequence` to allow rollback by renaming the sequence back to its previous name.

### Notes
- `rename_sequence` can be reversed by renaming the sequence back to its previous name.

## [1.1.0](https://github.com/shivam091/postgresql_adapter_extensions/compare/v1.0.0...v1.1.0) - 2025-03-21

### What's new

#### PostgreSQLAdapterExtensions::CommandRecorder
- Added `create_sequence` method to record sequence creation in migrations.
- Added `alter_sequence` method to record sequence alterations (irreversible).
- Added `drop_sequence` method to record sequence deletions (irreversible).
- Implemented `invert_create_sequence` to allow rollback by dropping the sequence.
- Implemented `invert_alter_sequence` and `invert_drop_sequence` to raise `ActiveRecord::IrreversibleMigration`.

### Notes
- `create_sequence` can be reversed by dropping the sequence.
- `alter_sequence` and `drop_sequence` are irreversible operations.

## [1.0.0](https://github.com/shivam091/postgresql_adapter_extensions/compare/v0.1.0...v1.0.0) - 2025-03-12

### What's new

#### PostgreSQLAdapterExtensions::SequenceMethods
- Added `create_sequence` method to allow creating PostgreSQL sequences with customizable options such as
  start value, increment step, min/max values, caching, cycling, and ownership.

- Added `alter_sequence` method to enable modifying existing PostgreSQL sequences, supporting changes to
  increment steps, restart values, min/max limits, caching, cycling behavior, and ownership.

- Added `drop_sequence` method to provides functionality to remove a PostgreSQL sequence with optional
  IF EXISTS and CASCADE/RESTRICT behaviors to manage dependencies.

## 0.1.0 - 2025-03-11

### Initial release
