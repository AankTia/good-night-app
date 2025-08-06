require "rails_helper"

RSpec.describe 'UserFollowingsController', type: :routing do
  let(:user) { create(:user) }
  let(:target_user) { create(:user) }

  describe "routing" do
    it "routes to #create" do
      expect(post: "/api/v1/users/#{user.id}/followings").to route_to("api/v1/user_followings#create", user_id: user.id.to_s)
    end

    it "routes to #index" do
      expect(get: "/api/v1/users/#{user.id}/followings").to route_to("api/v1/user_followings#index", user_id: user.id.to_s)
    end

    it "routes to #destroy" do
      expect(delete: "/api/v1/users/#{user.id}/followings/#{target_user.id}").to route_to("api/v1/user_followings#destroy", user_id: user.id.to_s, target_user_id: target_user.id.to_s)
    end
  end
end
