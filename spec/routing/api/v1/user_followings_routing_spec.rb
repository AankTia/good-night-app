require "rails_helper"

RSpec.describe 'UserFollowingsController', type: :routing do
  let(:user) { create(:user) }

  describe "routing" do
    it "routes to #create" do
      expect(post: "/api/v1/followings").to route_to("api/v1/user_followings#create")
    end

    it "routes to #index" do
      expect(get: "/api/v1/followings").to route_to("api/v1/user_followings#index")
    end

    it "routes to #destroy" do
      expect(delete: "/api/v1/followings/#{user.id}").to route_to("api/v1/user_followings#destroy", target_user_id: user.id.to_s)
    end
  end
end
