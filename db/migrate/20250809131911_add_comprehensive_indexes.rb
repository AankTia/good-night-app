class AddComprehensiveIndexes < ActiveRecord::Migration[7.1]
  def change
    # =========================================
    # SLEEP RECORD - HIGH VOLUME OPTIMIZATIONS
    # =========================================

    # Composite index for friend's sleep records query (most critical)
    # Covers: user_id, created_at range + duration seconds ordering
    add_index :sleep_records,
              [:user_id, :created_at, :duration_seconds],
              name: 'idx_sleep_records_user_time_duration'

    # Partial index for active sleep records (wake_up_time IS NULL)
    execute <<-SQL
      CREATE INDEX idx_active_sleep_records
      ON sleep_records(user_id, sleep_time)
      WHERE wake_up_time IS NULL
    SQL

    # Partial index for completed sleep records with duration
    execute <<-SQL
      CREATE INDEX idx_completed_sleep_records
      ON sleep_records(user_id, duration_seconds, created_at)
      WHERE wake_up_time IS NOT NULL
    SQL

    # Time-based queries (last week, last month filters)
    add_index :sleep_records,
              [:created_at, :user_id],
              name: 'idx_sleep_records_time_user'

    # Duration analysis queries
    add_index :sleep_records,
              [:duration_seconds, :user_id, :created_at],
              name: 'idx_sleep_records_duration_analysis'
  end
end
