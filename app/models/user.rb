class User < ApplicationRecord
  has_many :sleep_records, dependent: :destroy
  has_many :followings, class_name: 'UserFollowing', foreign_key: 'follower_id', dependent: :destroy
  has_many :followers, class_name: 'UserFollowing', foreign_key: 'following_id', dependent: :destroy

  has_many :following_users, through: :followings, source: :following
  has_many :follower_users, through: :followers, source: :follower

  validates :name, presence: true, length: { maximum: 100 }

  def follow(user)
    return false if user == self || following?(user)
    followings.create(following: user)
  end

  # Batch-optimized following check
  def following?(user_or_id)
    user_id = user_or_id.is_a?(User) ? user_or_id.id : user_or_id

    # Use the optimized index for single lookups
    followings.exists?(following_id: user_id)
  end

  def unfollow(user)
    followings.find_by(following: user)&.destroy
  end

  def friends_sleep_records_last_week
    # Optimized query using the comprehensive index
    # idx_sleep_records_user_time_duration covers this entire query
    one_week_ago = 1.week.ago

    SleepRecord.joins(:user)
               .where(user: following_users)
               .where(created_at: one_week_ago..Time.current)
               .where.not(wake_up_time: nil) # Uses idx_completed_sleep_records
               .includes(:user)
               .order(:duration_seconds)
  end

  # Cached version for high-traffict scenarios
  def friends_sleep_records_last_week_cached
    Rails.cache.fetch(
      "user_#{id}_friends_sleep_#{Date.current}_v2",
      expires_in: 30.minutes,
      race_condition_ttl: 5.minutes
    ) do
      friends_sleep_records_last_week.to_a
    end
  end

  # Optimized following count
  def following_count
    Rails.cache.fetch("user_#{id}_following_count", expires_in: 1.hour) do
      followings.count
    end
  end

  # Sleep statistics (uses duration index)
  def sleep_stats(period = 1.month)
    Rails.cache.fetch("user_#{id}_sleep_stats_#{period.inspect}", expires_in: 1.hour) do
      records = sleep_records.completed
                             .where(created_at: period.ago..Time.current)

      {
        total_records: records.count,
        avg_duration: records.average(:duration_seconds)&.to_i,
        min_duration: records.minimum(:duration_seconds),
        max_duration: records.maximum(:duration_seconds),
        total_sleep_time: records.sum(:duration_seconds)
      }
    end
  end
end
