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

    # =========================================
    # User Followings - Relationship Queries
    # =========================================

    # Optimized for finding all users a person follows
    # (Already exists but ensuring optimal structure)
    remove_index :user_followings, [:follower_id, :following_id] if index_exists?(:user_followings, [:follower_id, :following_id])
    add_index :user_followings,
              [:follower_id, :following_id],
              unique: true,
              name: 'idx_user_followings_unique'

    # Optimized for finding followers of a user
    add_index :user_followings,
              [:following_id, :follower_id],
              name: 'idx_user_followings_reverse'

    # Time-based following analysis
    add_index :user_followings,
              [:follower_id, :created_at],
              name: 'idx_user_followings_time'
  end

  def down
    # Remove all custome indexes
    execute "DROP INDEX IF EXISTS idx_sleep_records_user_time_duration"
    execute "DROP INDEX IF EXISTS idx_active_sleep_records"
    execute "DROP INDEX IF EXISTS idx_completed_sleep_records"
    execute "DROP INDEX IF EXISTS idx_sleep_records_time_user"
    execute "DROP INDEX IF EXISTS idx_sleep_records_duration_analysis"
    execute "DROP INDEX IF EXISTS idx_user_followings_reverse"
    execute "DROP INDEX IF EXISTS idx_user_followings_time"
    execute "DROP INDEX IF EXISTS idx_users_name_lower"
    execute "DROP INDEX IF EXISTS idx_users_activity"

    remove_index :user_followings, name: 'idx_user_followings_unique'
    add_index :user_followings, [:follower_id, :following_id], unique: true
  end
end
