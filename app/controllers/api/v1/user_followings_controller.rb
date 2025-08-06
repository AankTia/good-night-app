class Api::V1::UserFollowingsController < ApplicationController
  before_action :find_user
  before_action :find_target_user, only: [:create, :destroy]

  # POST /api/v1/users/:user_id/followings
  def create
    if @user.follow(@target_user)
      render json: {
        message: "Successfully followed #{@target_user.name}",
        following: UserSerializer.new(@target_user)
      }, status: :created
    else
      render json: {
        error: 'Unable to follow user',
        details: ['Already following this user or invalid target']
      }, status: :unprocessable_content
    end
  end

  # GET /api/v1/users/:user_id/followings
  def index
    followings = @user.following_users
                      .page(params[:page])
                      .per(params[:per_page] || 50)
                    
    render json: {
      followings: ActiveModel::Serializer::CollectionSerializer.new(
        followings,
        serializer: UserSerializer
      ),
      pagination: {
        current_page: followings.current_page,
        total_pages: followings.total_pages,
        total_count: followings.total_count
      }
    }
  end

  # DELETE /api/v1/users/:user_id/followings/:target_user_id
  def destroy
    if @user.unfollow(@target_user)
      render json: {
        message: "Successfully unfollowed #{@target_user.name}"
      }
    else
      render json: {
        error: 'Unable to unfollow user',
        details: ['Not following this user']
      }, status: :unprocessable_content
    end
  end

  private

  def find_target_user
    @target_user = User.find(params[:target_user_id])
  end
end
