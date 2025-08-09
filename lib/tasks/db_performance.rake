namespace :db do
  desc "Analyze database performance and suggest optimizations"
  task performance: :environment do
    puts "=== Database Performance Analysis ==="
    puts "Environment: #{Rails.env}"

    connection = ActiveRecord::Base.connection

    # =====================
    # Index Usage Analysis
    # =====================
    puts "\n--- Index Usage Analysis ---"

    # Get all indexes
    indexes = connection.execute(<<-SQL)
      SELECT name, tbl_name, sql
      FROM sqlite_master
      WHERE type = 'index'
      AND name NOT LIKE 'sqlite_%'
      ORDER BY tbl_name, name
    SQL

    indexes.each do |index|
      puts "#{index['tbl_name']}.#{index['name']}"
    end

    # =====================
    # Table Statistic
    # =====================
    puts "\n--- Table Statistics ---"

    tables = ['users', 'sleep_records', 'user_followings']
    tables.each do |table|
      count = connection.execute("SELECT COUNT(*) as count FROM #{table}").first['count']
      analyze_result = connection.execute("ANALYZE #{table}; SELECT * FROM sqlite_stat1 WHERE tbl='#{table}")

      puts "#{table}: #{count} records"
      analyze_result.each do |stat|
        puts "  Index: #{stat['idx']} - Stats: #{stat['stat']}" if stat['idx']
      end
    end

    # =====================
    # Slow Query Simulation
    # =====================
    puts "\n--- Performance Testing ---"

    require 'benchmark'

    if User.count > 0 && SleepRecord.count > 0
      user = User.first

      # Test the friends sleep records query
      time = Benchmark.measure do
        user.friends_sleep_records_last_week.to_a
      end
      puts "Friend sleep records query: #{(time.real * 1000).round(2)}ms"

      # Test pagination query
      time = Benchmark.measure do
        SleepRecord.includes(:user).limit(50).to_a
      end
      puts "Paginated sleep records: #{(time.real * 1000).round(2)}ms"

      # Test following check
      if User.count > 1
        other_user = User.where.not(id: user.id).first
        time = Benchmark.measure do
          user.following?(other_user)
        end
        puts "Following check: #{(time.real * 1000).round(2)}ms"
      end
    end
  end
end