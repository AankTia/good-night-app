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

  def following?(user)
    following_users.include?(user)
  end

  def friends_sleep_records_last_week
    one_week_ago = 1.week.ago

    SleepRecord.joins(:user)
               .where(user: following_users)
               .where(created_at: one_week_ago..Time.current)
               .where.not(wake_up_time: nil)
               .order(:duration_seconds)
  end
end
