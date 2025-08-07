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
    sleep_records = @user.sleep_records
                         .ordered_by_created_time
                         .includes(:user)
                         .page(params[:page])
                         .per(params[:per_page] || 50)
    
    render json: {
      sleep_records: ActiveModel::Serializer::CollectionSerializer.new(
        sleep_records,
        serializer: SleepRecordSerializer
      ),
      pagination: {
        current_page: sleep_records.current_page,
        total_pages: sleep_records.total_pages,
        total_count: sleep_records.total_count
      }
    }
  end

  # GET  /api/v1/users/:user_id/sleep_records/:id
  def show
    sleep_record = @user.sleep_records.find(params[:id])

    render json: {
      sleep_record: SleepRecordSerializer.new(sleep_record)
    }
  end

  # GET /api/v1/users/:user_id/sleep_records/friends_sleep_records
  def friends_sleep_records
    cache_key = "user_#{@user.id}_friends_sleep_records_#{1.week.ago.to_date}"

    friends_records = Rails.cache.fetch(cache_key, expires_in: 1.hours) do
      @user.friends_sleep_records_last_week.to_a
    end

    render json: {
      sleep_records: ActiveModel::Serializer::CollectionSerializer.new(
        friends_records,
        serializer: SleepRecordSerializer
      ),
      summary: {
        total_records: friends_records.size,
        date_range: {
          from: 1.week.ago.to_date,
          to: Date.current
        }
      }
    }
  end
end
