class Api::V1::SleepRecordsController < ApplicationController
  before_action :find_user

  # POST /api/v1/users/:user_id/sleep_records
  def create
    # Clock in - create new sleep record
    sleep_record = @user.sleep_records.create!(sleep_time: Time.current)

    # Return all sleep records ordered by created time
    sleep_records = @user.sleep_records.ordered_by_created_time.includes(:user)

    render json: {
      message: 'Clocked in successfully',
      current_record: SleepRecordSerializer.new(sleep_record),
      all_records: ActiveModel::Serializer::CollectionSerializer.new(
        sleep_records,
        serializer: SleepRecordSerializer
      )
    }, status: :created
  end

  # GET  /api/v1/users/:user_id/sleep_records
  def index
  end

  # GET  /api/v1/users/:user_id/sleep_records/:id
  def show
  end

  # GET /api/v1/users/:user_id/sleep_records/friend_sleep_records
  def friend_sleep_records
  end
end
