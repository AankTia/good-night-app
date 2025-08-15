

require 'swagger_helper'

RSpec.describe 'user_followings', type: :request do
  path '/api/v1/users/{user_id}/followings' do
    get 'List user followings' do
      tags 'User Followings'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :integer, description: 'ID of the user', example: 1

      response '200', 'Followings found' do
        schema type: :object,
                properties: {
                  followings: {
                    type: :array,
                    items: {
                      type: :object,
                      properties: {
                        id: { type: :integer },
                        name: { type: :string, example: 'John Doe' },
                        created_at: { type: :string, format: 'date-time', example: '2023-10-01T12:00:00Z' },
                      },
                      required: ['id', 'name', 'created_at']
                    }
                  },
                  pagination: {
                    type: :object,
                    properties: {
                      current_page: { type: :integer, example: 1 },
                      total_pages: { type: :integer, example: 10 },
                      total_count: { type: :integer, example: 100 }
                    }
                  }
                }

        let(:user_id) { 1 }
        run_test!
      end

      response '404', 'User not found' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'User not found' }
               }

        let(:user_id) { 9999 } # Assuming this user does not exist
        run_test!
      end
    end
  end

  path '/api/v1/users/{user_id}/followings' do
    post 'Create a following' do
      tags 'User Followings'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :integer, description: 'ID of the user', example: 1
      parameter name: :following_id, in: :query, type: :integer, description: 'ID of the user to follow', example: 2

      response '201', 'Following created' do
        schema type: :object,
               properties: {
                 message: { type: :string, example: 'Successfully followed Kathyrn Mann VM' },
                 following: {
                   type: :object,
                   properties: {
                     id: { type: :integer, example: 1 },
                     name: { type: :string, example: 'Kathyrn Mann VM1' },
                     created_at: { type: :string, format: 'date-time', example: '2023-10-01T12:00:00Z' }
                   }
                 }
               },
               required: ['id', 'name', 'created_at']

        let(:user_id) { 1 }
        let(:following_id) { 2 } # Assuming this user exists
        run_test!
      end

      response '404', 'User or target user not found' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Record not found' }
               }

        let(:user_id) { 9999 } # Assuming this user does not exist
        let(:following_id) { 2 } # Assuming this user exists
        run_test!
      end

      response '422', 'Already following user or invalid target' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Unable to follow user' },
                 details: { 
                  type: :object,
                  properties: {
                    details: { type: :string, example: 'Already following this user or invalid target' }
                  }
                }
              }

        let(:user_id) { 1 }
        let(:following_id) { 2 }
        run_test!
      end
    end
  end

  path '/api/v1/users/{user_id}/followings/{target_user_id}' do
    delete 'Unfollow a user' do
      tags 'User Followings'
      produces 'application/json'
      parameter name: :user_id, in: :path, type: :integer, description: 'ID of the user', example: 1
      parameter name: :target_user_id, in: :path, type: :integer, description: 'ID of the user to unfollow', example: 2

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

      response '422', 'Invalid parameters' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Invalid parameters' }
               }

        # This response is for when the target_user_id is missing or invalid
        # Adjust the test case as needed based on your application's validation logic
        let(:user_id) { 1 }
        let(:target_user_id) { nil } # Missing target_user_id
        run_test!
      end
    end
  end
end