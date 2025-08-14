require 'swagger_helper'

RSpec.describe 'api/sleep_records', type: :request do

  path '/api/v1/users/1/sleep_records/1' do
    get 'Detail' do
      tags 'Sleep Records'
      produces 'application/json'
      # parameter name: 'id', in: :path, type: :string
      # request_body_example value: { some_field: 'Foo' }, name: 'basic', summary: 'Request example description'

      response '200', 'Record found' do
        schema type: :object,
          properties: {
          #   id: { type: :integer },
          #   title: { type: :string },
          #   content: { type: :string }
              sleep_record: {
                  id: { type: :integer },
                  "sleep_time": {type: :string, format: 'date-time'},
                  "wake_up_time": "2025-07-02T20:28:47Z",
                  "duration_hours": 7.0,
                  "duration_seconds": 25200,
                  "created_at": "2025-08-13T14:28:03Z",
                  "user": {
                      "id": 1,
                      "name": "Jona Davis I",
                      "created_at": "2025-08-13T14:27:38Z"
                  }
              }
          },
          required: [ 'id', 'title', 'content' ]

        # let(:request_params) { 'id' => { Blog.create(title: 'foo', content: 'bar').id } }
        run_test!
      end

      response '404', 'Record not found' do
        let(:request_params) { { 'id' => 'invalid' } }
        run_test!
      end

      # response '406', 'unsupported accept header' do
      #   let(:request_headers) { { 'Accept' => 'application/foo' } }
      #   run_test!
      # end
    end
  end
end
