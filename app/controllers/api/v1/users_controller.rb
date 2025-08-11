class Api::V1::UsersController < ApplicationController

  def index
    users = User.limit(10)  # Limit to prevent large payloads

    render json: {
      users: ActiveModel::Serializer::CollectionSerializer.new(
        users,
        serializer: UserSerializer
      ),
      pagination_notes: 'Showing latest 10 records. Use /sleep_records for full pagination.'
    }, status: :ok
  end
end