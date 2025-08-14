

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
end