class Api::V1::SleepRecordsController < ApplicationController
  before_action :find_user

  # POST /api/v1/users/:user_id/sleep_records
  def create
    #  Check if user has an active (uncompleted) sleep record
    active_record = @user.sleep_records
                         .active
                         .first

    if active_record
      # Clock out - set wake up time
      active_record.update!(wake_up_time: Time.current)
      sleep_record = active_record

      # Invalidate user statistics cache
      invalidate_user_caches
    else
      # Clock in - create new sleep record
      sleep_record = @user.sleep_records.create!(sleep_time: Time.current)
    end

    # Use cached count for large dataset
    total_records = Rails.cache.fetch("user_#{@user_id}_sleep_records_count", expires_in: 5.minutes) do
      @user.sleep_records.count
    end

    # Return paginated results for large dataset
    sleep_records = @user.sleep_records
                         .ordered_by_created_time
                         .includes(:user)
                         .limit(20)  # Limit to prevent large payloads

    render json: {
      message: active_record ? 'Clocked out successfully' : 'Clocked in successfully',
      current_record: SleepRecordSerializer.new(sleep_record),
      all_records: ActiveModel::Serializer::CollectionSerializer.new(
        sleep_records,
        serializer: SleepRecordSerializer
      ),
      total_count: total_records,
      pagination_notes: 'Showing latest 20 records. Use /sleep_records for full pagination.'
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
    # Multi-level caching for high-traffic scenarios
    cache_key = "user_#{@user.id}_friends_sleep_v3_#{Date.current}"

    friends_records = Rails.cache.fetch(cache_key, expires_in: 1.hours) do
      # Use the optimized cached method
      @user.friends_sleep_records_last_week_cached
    end

    # Additional metadaa for large datasets
    following_count = @user.following_count

    render json: {
      sleep_records: ActiveModel::Serializer::CollectionSerializer.new(
        friends_records,
        serializer: SleepRecordSerializer
      ),
      summary: {
        total_records: friends_records.size,
        following_count: following_count,
        date_range: {
          from: 1.week.ago.to_date,
          to: Date.current
        },
        cached: true,
        cache_expires_id: "1 hour"
      }
    }
  end

  private

  def invalidate_user_caches
    Rails.cache.delete("user_#{@user.id}_sleep_records_count")
    Rails.cache.delete_matched("user_#{@user.id}_sleep_stats_*")
    Rails.cache.delete_matched("user_#{@user.id}_friends_sleep_*")
  end
end
