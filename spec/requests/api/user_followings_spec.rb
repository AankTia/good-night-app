

require 'swagger_helper'

RSpec.describe 'user_followings', type: :request do
  path '/api/v1/users/{user_id}/followings' do
    get 'List user followings' do
      tags 'User Followings'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :integer, description: 'ID of the user'

      response '200', 'Followings found' do
        schema type: :array, items: {
          type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string, example: 'John Doe' },
            created_at: { type: :string, format: 'date-time' }
          },
          required: ['id', 'name', 'created_at']
        }

        let(:user_id) { 1 }
        run_test!
      end

      response '404', 'User not found' do
        let(:user_id) { 9999 } # Assuming this user does not exist
        run_test!
      end
    end
  end

  path '/api/v1/users/{user_id}/followings' do
    post 'Create a following' do
      tags 'User Followings'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :integer, description: 'ID of the user'
      parameter name: :following_id, in: :query, type: :integer, description: 'ID of the user to follow'

      response '201', 'Following created' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 follower_id: { type: :integer },
                 following_id: { type: :integer },
                 created_at: { type: :string, format: 'date-time' }
               },
               required: ['id', 'follower_id', 'following_id', 'created_at']

        let(:user_id) { 1 }
        let(:following_id) { 2 } # Assuming this user exists
        run_test!
      end

      response '422', 'Invalid parameters' do
        let(:user_id) { 1 }
        let(:following_id) { nil } # Missing following_id
        run_test!
      end
    end
  end

  path '/api/v1/users/{user_id}/followings/{target_user_id}' do
    delete 'Unfollow a user' do
      tags 'User Followings'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :integer, description: 'ID of the user'
      parameter name: :target_user_id, in: :path, type: :integer, description: 'ID of the user to unfollow'

      response '204', 'Successfully unfollowed' do
        let(:user_id) { 1 }
        let(:target_user_id) { 2 } # Assuming this user is being followed
        run_test!
      end

      response '404', 'Following not found' do
        let(:user_id) { 1 }
        let(:target_user_id) { 9999 } # Assuming this user is not being followed
        run_test!
      end
    end
  end
end