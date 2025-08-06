class SleepRecordSerializer < ActiveModel::Serializer
  attributes :id, :sleep_time, :wake_up_time, :duration_hours, :duration_seconds, :created_at
  belongs_to :user, serializer: UserSerializer

  def sleep_time
    object.sleep_time.iso8601
  end

  def wake_up_time
    object.wake_up_time&.iso8601
  end

  def created_at
    object.created_at.iso8601
  end
end
