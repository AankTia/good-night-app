module PerformanceMonitoring
  extend ActiveSupport::Concern

  included do
    # Monitor slow queries
    around_action :log_query_performance
  end

  private

  def log_query_performance
    start_time = Time.current
    result = yield
    duration = (Time.current - start_time) * 1000

    if duration > 1000 # Log queries slower than 1 second
      Rails.logger.warn("SLOW QUERY: #{request.path} took #{duration.round(2)}ms")
    end

    result
  end
end