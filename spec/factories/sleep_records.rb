FactoryBot.define do
  factory :sleep_record do
    association :user
  end

  trait :completed do
    sleep_time { 8.hours.ago }
    wake_up_time { 1.hour.ago }
  end
end
