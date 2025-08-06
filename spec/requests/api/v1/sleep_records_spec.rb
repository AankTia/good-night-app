require 'rails_helper'

RSpec.describe 'Api::V1::SleepRecords', type: :request do
  let(:user) { create(:user) }

  describe 'POST /api/v1/users/:user_id/sleep_records' do
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
  end
end