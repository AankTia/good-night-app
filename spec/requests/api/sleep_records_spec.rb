require 'swagger_helper'

RSpec.describe 'api/sleep_records', type: :request do

  path '/api/v1/users/{user_id}/sleep_records' do
    post 'Create or Update Sleep Record' do
      tags 'Sleep Records'
      produces 'application/json'
      description 'Create a new sleep record or update an existing one for a given user'
      parameter name: 'user_id', in: :path, type: :integer, required: true, description: 'ID of the user', example: 1
      parameter name: :sleep_record, in: :body, required: true, schema: {
        type: :object,
        properties: {
          sleep_time: { type: :string, format: 'date-time', example: '2025-07-02T20:28:47Z' },
          wake_up_time: { type: :string, format: 'date-time', example: '2025-07-03T05:28:47Z' }
        },
        required: [ 'sleep_time' ]
      }

      response '201', 'Record created' do
        schema type: :object,
          properties: {
            message: { type: :string, example: 'Sleep record created successfully' },
            current_record: {
              type: :object,
              properties: {
                id: { type: :integer },
                sleep_time: { type: :string, format: 'date-time' },
                wake_up_time: { type: :string, format: 'date-time' },
                duration_seconds: { type: :integer },
                created_at: { type: :string, format: 'date-time' },
                user: {
                  type: :object,
                  properties: {
                    id: { type: :integer },
                    name: { type: :string },
                    created_at: { type: :string, format: 'date-time' }
                  }
                }
              },
              required: [ 'id', 'sleep_time', 'wake_up_time', 'duration_seconds', 'created_at', 'user' ]
            },
          all_records: {
            type: :array,
            items: {
              '$ref': '#/components/schemas/SleepRecord'
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

        let(:user_id) { 'invalid' }
        run_test!
      end

      response '422', 'Invalid parameters' do
        let(:user_id) { 1 }
        let(:sleep_record) { { sleep_time: 'invalid-date' } }
        run_test!
      end
    end
  end

  path '/api/v1/users/{user_id}/sleep_records/{id}' do
    get 'Detail' do
      tags 'Sleep Records'
      produces 'application/json'
      description 'Get details of a specific sleep record for a given user'
      parameter name: 'user_id', in: :path, type: :integer, required: true, description: 'ID of the user', example: 1
      parameter name: 'id', in: :path, type: :integer, required: true, description: 'ID of the sleep record', example: 1

      response '200', 'Record found' do
        schema type: :object,
          properties: {
              sleep_record: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  sleep_time: { type: :string, format: 'date-time' },
                  wake_up_time: { type: :string, format: 'date-time' },
                  duration_seconds: { type: :integer },
                  created_at: { type: :string, format: 'date-time' },
                  user: {
                    type: :object,
                    properties: {
                      id: { type: :integer },
                      name: { type: :string },
                      created_at: { type: :string, format: 'date-time' }
                    }
                  }
                },
                required: [ 'id', 'sleep_time', 'wake_up_time', 'duration_seconds', 'created_at', 'user' ]
              }
          },
          example: {
              sleep_record: {
                  id: 1,
                  sleep_time: "2025-07-02T20:28:47Z",
                  wake_up_time: "2025-07-03T05:28:47Z",
                  duration_seconds: 32400,
                  created_at: "2025-08-13T14:28:03Z",
                  user: {
                      id: 1,
                      name: "Jona Davis I",
                      created_at: "2025-08-13T14:27:38Z"
                  }
              }
          },
          required: [ 'sleep_record' ]

        let(:user_id) { 1 }
        let(:id) { 1 }

        run_test!
      end

      response '404', 'Record not found' do
        let(:user_id) { 1 }
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/v1/users/{user_id}/sleep_records' do
    get 'List' do
      tags 'Sleep Records'
      produces 'application/json'
      description 'List all sleep records for a given user with pagination'
      parameter name: 'user_id', in: :path, type: :integer, required: true, description: 'ID of the user', example: 1
      parameter name: :page, in: :query, type: :integer, description: 'Page number for pagination', example: 1
      parameter name: :per_page, in: :query, type: :integer, description: 'Number of records per page', example: 10

      response '200', 'Records found' do
        schema type: :object,
          properties: {
            sleep_records: {
              type: :array,
              items: { '$ref': '#/components/schemas/SleepRecord' }
            },
            pagination: {
              type: :object,
              properties: {
                current_page: { type: :integer, example: 1 },
                total_pages: { type: :integer, example: 5 },
                total_count: { type: :integer, example: 50 },
                next_cursor: { type: :integer, nullable: true, example: 11 },
                per_page: { type: :integer, example: 10 }
              }
            }
          }

        let(:user_id) { 1 }
        let(:page) { 1 }
        let(:per_page) { 10 }

        run_test!
      end

      response '404', 'User not found' do
        schema type: :object,
          properties: {
            error: { type: :string, example: 'User not found' }
          }

        let(:user_id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/api/v1/users/{user_id}/sleep_records/friends_sleep_records' do
    get 'Friends Sleep Records' do
      tags 'Sleep Records'
      produces 'application/json'
      description 'Get sleep records of friends for a given user'
      parameter name: 'user_id', in: :path, type: :integer, required: true, description: 'ID of the user', example: 1

      response '200', 'Records found' do
        schema type: :object,
          properties: {
            sleep_records: {
              type: :array,
              items: { '$ref': '#/components/schemas/SleepRecord' }
            },
            summary: {
              type: :object,
              properties: {
                total_records: { type: :integer, example: 20 },
                following_count: { type: :integer, example: 5 },
                date_range: {
                  type: :object,
                  properties: {
                    from: { type: :string, format: 'date', example: '2025-07-01' },
                    to: { type: :string, format: 'date', example: '2025-07-08' }
                  }
                },
                cached: { type: :boolean, example: true },
                cache_expires_id: { type: :string, example: '1 hour' }
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

        let(:user_id) { 'invalid' }
        run_test!
      end
    end
  end
end
