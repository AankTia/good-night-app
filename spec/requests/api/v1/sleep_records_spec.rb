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
end