class UserFollowing < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :following, class_name: 'User'

  validates :follower_id, uniqueness: { scope: :following_id }
  validate :cannot_follow_self

  private

  def cannot_follow_self
    return unless follower_id && following_id

    if follower_id == following_id
      errors.add(following_id: 'cannot follow yourself')
    end
  end
end
