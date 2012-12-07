# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :mass_assignable_inventory_group, :class => InventoryGroup do
    name { Faker::Lorem.words(2).join(" ") }
  end

  factory :inventory_group do
    name { Faker::Lorem.words(2).join(" ") }
    user
  end
end
