# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'factory_bot_rails'
include FactoryBot::Syntax::Methods

puts "Seeding Dummy Users"
5.times do
  user = create(:user)
  create_list(:sleep_record, 3, :completed, user: user)
end

user = User.first
User.where
    .not(id: user.id)
    .each { |target_user| user.follow(target_user) }
