class Api::V1::SleepRecordsController < ApplicationController
  before_action :find_user

  # POST /api/v1/users/:user_id/sleep_records
  def create
    #  Check if user has an active (uncompleted) sleep record
    active_record = @user.sleep_records.find_by(wake_up_time: nil)

    if active_record
      # Clock out - set wake up time
      active_record.update!(wake_up_time: Time.current)
      sleep_record = active_record
    else
      # Clock in - create new sleep record
      sleep_record = @user.sleep_records.create!(sleep_time: Time.current)
    end

    # Return all sleep records ordered by created time
    sleep_records = @user.sleep_records.ordered_by_created_time.includes(:user)

    render json: {
      message: active_record ? 'Clocked out successfully' : 'Clocked in successfully',
      current_record: SleepRecordSerializer.new(sleep_record),
      all_records: ActiveModel::Serializer::CollectionSerializer.new(
        sleep_records,
        serializer: SleepRecordSerializer
      )
    }, status: active_record ? :ok : :created
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
