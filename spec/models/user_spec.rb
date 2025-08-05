require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:sleep_records).dependent(:destroy) }
    it { should have_many(:followings).dependent(:destroy) }
    it { should have_many(:followers).dependent(:destroy) }
    it { should have_many(:following_users).through(:followings) }
    it { should have_many(:follower_users).through(:followers) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(100) }
  end

  describe '#follow' do 
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    it 'creates a following relationship' do
      expect { user1.follow(user2) }.to change { user1.followings.count }.by(1)
    end

    it 'returns false when trying to follow self' do
      expect(user1.follow(user1)).to be_falsey
    end

    it 'returns false when already following' do
      user1.follow(user2)
      expect(user1.follow(user2)).to be_falsey
    end
  end
end
