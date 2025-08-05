require 'rails_helper'

RSpec.describe SleepRecord, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:sleep_time) }

    it 'validates wake_up_time is after sleep_time' do
      record = build(:sleep_record, sleep_time: 2.hours.ago, wake_up_time: 3.hours.ago)

      expect(record).not_to be_valid
      expect(record.errors[:wake_up_time]).to include('must be after sleep time')
    end
  end

  describe '#calculate_duration' do
    it 'calculates duration in seconds when both times are present' do
      record = create(:sleep_record, sleep_time: 8.hours.ago, wake_up_time: 1.hour.ago)

      expect(record.duration_seconds).to eq(7 * 3600) # 7 hours in seconds
    end
  end
end
