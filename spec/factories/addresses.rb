# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :mass_assignable_address, :class => Address do
    name { Faker::Lorem.words.join(" ") }
    address_1 { Faker::Address.street_address }
    address_2 { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    zip_code { Faker::Address.zip_code }
  end

  factory :address, :parent => :mass_assignable_address do
    user
    is_default_shipping false
    is_default_billing false
  end
end
