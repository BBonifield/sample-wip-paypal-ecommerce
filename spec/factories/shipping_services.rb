# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shipping_service do
    name { Faker::Lorem.words(3).join(" ") }
    logo_identifier { Faker::Lorem.word }
    sort_order { (Random.rand * 100).round }
  end
end
