require 'rails_helper'

RSpec.describe 'Api::V1::UserFollowings', type: :request do
  let(:user) { create(:user) }
  let(:target_user) { create(:user) }

  describe '(create) POST /api/v1/users/:user_id/followings' do
    it 'creates a following relationship' do
      expect {
        post "/api/v1/users/#{user.id}/followings", params: { target_user_id: target_user.id}
      }.to change { user.followings.count }.by(1)

      expect(response).to have_http_status(:created)

      json = JSON.parse(response.body)
      expect(json['message']).to include('Successfully followed')
    end

    it 'returns error when trying to follow the same target user twice' do
      user.follow(target_user)

      post "/api/v1/users/#{user.id}/followings", params: { target_user_id: target_user.id }

      expect(response).to have_http_status(:unprocessable_content)

      json = JSON.parse(response.body)
      expect(json['error']).to eq('Unable to follow user')
    end

    it 'returns error when trying to follow invalid target user' do
      post "/api/v1/users/#{user.id}/followings", params: { target_user_id: '0' }

      expect(response).to have_http_status(:not_found)

      json = JSON.parse(response.body)
      expect(json['error']).to eq('Record not found')
    end
  end

  describe '(delete) DELETE /api/v1/users/:user_id/followings' do
    before do
      user.follow(target_user)
    end

    it 'removes the following relationship' do
      expect {
        delete "/api/v1/users/#{user.id}/followings/#{target_user.id}"
      }.to change { user.followings.count }.by(-1)

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json['message']).to include('Successfully unfollowed')
    end
  end
end