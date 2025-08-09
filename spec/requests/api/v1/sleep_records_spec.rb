require 'rails_helper'

RSpec.describe 'Api::V1::SleepRecords', type: :request do
  let(:user) { create(:user) }

  describe '(create) POST /api/v1/users/:user_id/sleep_records' do
    context 'when clocking in (no active record)' do
      it 'creates a new sleep record' do
        expect {
          post "/api/v1/users/#{user.id}/sleep_records"
        }.to change { user.sleep_records.count }.by(1)

        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body)
        expect(json['message']).to eq('Clocked in successfully')
        expect(json['current_record']['wake_up_time']).to be_nil
      end
    end

    context 'when clocking out (active record exists)' do
      let!(:active_record) { create(:sleep_record, :active, user: user) }

      it 'updates the existing record with wake_up_time' do
        expect {
          post "/api/v1/users/#{user.id}/sleep_records"
        }.not_to change { user.sleep_records.count }

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json['message']).to eq('Clocked out successfully')
        expect(json['current_record']['wake_up_time']).not_to be_nil

        active_record.reload
        expect(active_record.wake_up_time).not_to be_nil
      end
    end
  end

  describe '(index) GET /api/v1/users/:user_id/sleep_records' do
    before do
      create_list(:sleep_record, 3, :completed, user: user)
    end

    it 'return paginated sleep records order by created time' do
      get "/api/v1/users/#{user.id}/sleep_records"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json['sleep_records'].size).to eq(3)
      expect(json['pagination']).to be_present
    end
  end

  describe '(show) GET /api/v1/users/:user_id/sleep_records/1' do
    context 'when record is exists' do
      before do
        create_list(:sleep_record, 3, :completed, user: user)
      end

      it 'return record data' do
        get "/api/v1/users/#{user.id}/sleep_records/#{user.sleep_records.last.id}"

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json['sleep_record']).to be_present
        expect(json['sleep_record']['user']).to be_present
      end
    end

    context 'when record is not exists' do
      before do
        create_list(:sleep_record, 3, :completed, user: user)
      end

      it 'return record data' do
        get "/api/v1/users/#{user.id}/sleep_records/0"

        expect(response).to have_http_status(:not_found)

        json = JSON.parse(response.body)
        expect(json['error']).to be_present
        expect(json['error']).to eq('Record not found')
      end
    end
  end

  describe '(friends_sleep_records) GET /api/v1/users/:user_id/friends_sleep_records' do
    let(:friend1) { create(:user) }
    let(:friend2) { create(:user) }

    before do 
      user.follow(friend1)
      user.follow(friend2)

      create(:sleep_record, :completed, user: friend1,
             sleep_time: 2.days.ago, wake_up_time: 2.days.ago + 6.hours)
      create(:sleep_record, :completed, user: friend2,
             sleep_time: 1.day.ago, wake_up_time: 1.day.ago + 8.hours)
    end

    it 'returns friend sleep records from last week ordered by duration' do
      get "/api/v1/users/#{user.id}/sleep_records/friends_sleep_records"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['sleep_records'].size).to eq(2)
      expect(json['summary']['total_records']).to eq(2)

      # verify ordering by duration (shortest first)
      durations = json['sleep_records'].map { |r| r['duration_seconds'] }
      expect(durations).to eq(durations.sort)
    end
  end

  describe '(stats) GET /api/v1/users/:user_id/sleep_records/friends_sleep_records' do
    before do
      create_list(:sleep_record, 3, :completed, user: user)
    end

    it 'returns sleep records statistics' do
      get "/api/v1/users/#{user.id}/sleep_records/stats"
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json['user_id']).to be_present
      expect(json['period_days']).to be_present
      expect(json['statistics']).to be_present
    end
  end
end