require "rails_helper"

RSpec.describe 'SleepRecordsController', type: :routing do
  let(:user) { create(:user) }

  describe "routing" do
    it "routes to #index" do
      expect(get "/api/v1/users/#{user.id}/sleep_records").to route_to("api/v1/sleep_records#index", user_id: user.id.to_s)
    end

    it "routes to #create" do
      expect(post "/api/v1/users/#{user.id}/sleep_records").to route_to("api/v1/sleep_records#create", user_id: user.id.to_s)
    end

    it "routes to #show" do
      expect(get "/api/v1/users/#{user.id}/sleep_records/1").to route_to("api/v1/sleep_records#show", user_id: user.id.to_s, id: '1')
    end

    it "routes to #friend_sleep_records" do
      expect(get "/api/v1/users/#{user.id}/sleep_records/friend_sleep_records").to route_to("api/v1/sleep_records#friend_sleep_records", user_id: user.id.to_s)
    end
  end
end