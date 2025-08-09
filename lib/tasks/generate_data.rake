namespace :db do
  desc "Generate data"
  task generate_data: :environment do
    puts "Generatng data..."

    # Create users
    require 'factory_bot_rails'
    include FactoryBot::Syntax::Methods

    users = []
    500.times do |i|
      users << create(:user)
      print "." if i % 10 == 0
    end
    puts " Created #{users.count} users"

    # Create followings (each user follows 10-20 random others)
    users.each_with_index do |user, i|
      following_count = rand(10..20)
      other_users = (users - [user]).sample(following_count)

      other_users.each do |other_user|
        UserFollowing.create!(follower: user, following: other_user)
      end

      print "." if i % 10 == 0
    end
    puts " Created user relationships"

    # Create sleep records (10-50 records per user over the last 3 months)
    users.each_with_index do |user, i|
      record_count = rand(10..50)

      record_count.times do |j|
        sleep_time = rand(3.months.ago..Time.current)
        wake_time = sleep_time + rand(4..12).hours

        SleepRecord.create!(
          user: user,
          sleep_time: sleep_time,
          wake_up_time: wake_time
        )
      end
      print "." if i % 10 == 0
    end
    puts " Created sleep records"

    puts "\n=== Test Data Summary ==="
    puts "Users: #{User.count}"
    puts "User Followings: #{UserFollowing.count}"
    puts "Sleep Records: #{SleepRecord.count}"
    puts "Average records per user: #{SleepRecord.count / User.count}"
  end
end