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

  describe '#friends_sleep_records_last_week' do
    let(:user) { create(:user) }
    let(:friend1) { create(:user) }
    let(:friend2) { create(:user) }

    before do
      user.follow(friend1)
      user.follow(friend2)
    end

    it 'return sleep records from friend is the last week ordered by duration' do
      # Create records with dirrefernt durations
      record1 = create(:sleep_record, :completed, user: friend1,
                      created_at: 2.days.ago, sleep_time: 2.days.ago, wake_up_time: 2.days.ago + 6.hours)
      record2 = create(:sleep_record, :completed, user: friend2,
                      created_at: 1.day.ago, sleep_time: 1.day.ago, wake_up_time: 1.day.ago + 8.hours)
      
      # Old record (should not be included)
      create(:sleep_record, :completed, user: friend1,
            created_at: 2.weeks.ago, sleep_time: 2.weeks.ago, wake_up_time: 2.weeks.ago + 7.hours)

      records = user.friends_sleep_records_last_week
      expect(records.count).to eq(2)
      expect(records.first).to eq(record1) # 6 hours (shorter duration first)
      expect(records.last).to eq(record2) # 8 hours
    end
  end
end
