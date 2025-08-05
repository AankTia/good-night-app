require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:sleep_records).dependent(:destroy) }
    it { should have_many(:followings).dependent(:destroy) }
    it { should have_many(:followers).dependent(:destroy) }
    it { should have_many(:following_users).through(:followings) }
    it { should have_many(:follower_users).through(:followers) }
  end
end
