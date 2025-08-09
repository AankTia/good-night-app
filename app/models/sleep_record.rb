class SleepRecord < ApplicationRecord
  belongs_to :user

  validates :sleep_time, presence: true
  validate :wake_up_time_after_sleep_time, if: :wake_up_time?

  scope :ordered_by_created_time, -> { order(:created_at) }
  scope :completed, -> { where.not(wake_up_time: nil) }
  scope :active, -> { where(wake_up_time: nil) }
  scope :last_week, -> { where(created_at: 1.week.ago..Time.current) }
  scope :last_month, -> { where(created_at: 1.month.ago..Time.current) }

  # Duration-based scope (uses duration index)
  scope :short_sleep, -> { completed.where('duration_seconds < ?', 6 * 3600) }
  scope :normal_sleep, -> { completed.where(duration_seconds: (6 * 3600)..(9 * 3600))}
  scope :long_sleep, -> { completed.where('duration_seconds > ?', 9 * 3600) }

  # Batch operation scope
  scope :for_users, ->(user_ids) { where(user_id: user_ids) }

  before_save :calculate_duration

  def clocked_in?
    wake_up_time.nil?
  end

  def duration_hours
    return nil unless duration_seconds
    (duration_seconds / 3600.0).round(2)
  end

  private

  def wake_up_time_after_sleep_time
    return unless wake_up_time && sleep_time

    if wake_up_time <= sleep_time
      errors.add(:wake_up_time, "must be after sleep time")
    end
  end

  def calculate_duration
    return unless wake_up_time && sleep_time

    self.duration_seconds = (wake_up_time - sleep_time).to_i
  end
end
