# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :purchase do
    order
    return_url { Faker::Internet.url }
    cancel_url { Faker::Internet.url }
    ipn_notification_url { Faker::Internet.url }
  end
end
