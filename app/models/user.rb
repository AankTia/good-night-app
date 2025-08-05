class User < ApplicationRecord
  has_many :sleep_records, dependent: :destroy
  has_many :followings, class_name: 'UserFollowing', foreign_key: 'follower_id', dependent: :destroy
  has_many :followers, class_name: 'UserFollowing', foreign_key: 'Following_id', dependent: :destroy

  has_many :following_users, through: :followings, source: :following
  has_many :follower_users, through: :followers, source: :follower

  validates :name, presence: true, length: { maximum: 100 }
end
