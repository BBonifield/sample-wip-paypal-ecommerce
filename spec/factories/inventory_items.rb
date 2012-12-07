# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :mass_assignable_inventory_item, :class => InventoryItem do
    name { Faker::Lorem.words(3).join(" ") }
    category_id { FactoryGirl.create(:category).id }
    condition_id { FactoryGirl.create(:condition).id }
    shipping_speed_id { FactoryGirl.create(:shipping_speed).id }
    quantity { 1 + (Random.rand * 10).ceil }
    shipping_cost { 1 + (Random.rand * 1000).ceil / 100 }
    details { Faker::Lorem.paragraphs(3).join("\n\n") }
    keyword_1 { Faker::Lorem.word }
    keyword_2 { Faker::Lorem.word }
    keyword_3 { Faker::Lorem.word }
    keyword_4 { Faker::Lorem.word }
    keyword_5 { Faker::Lorem.word }
    keyword_6 { Faker::Lorem.word }
  end

  factory :inventory_item do
    name { Faker::Lorem.words(3).join(" ") }
    category
    condition
    user
    shipping_speed
    quantity { 1 + (Random.rand * 10).ceil }
    shipping_cost { 1 + (Random.rand * 1000).ceil / 100 }
    details { Faker::Lorem.paragraphs(3).join("\n\n") }
    keyword_1 { Faker::Lorem.word }
    keyword_2 { Faker::Lorem.word }
    keyword_3 { Faker::Lorem.word }
    keyword_4 { Faker::Lorem.word }
    keyword_5 { Faker::Lorem.word }
    keyword_6 { Faker::Lorem.word }
    inventory_image { File.open("#{Rails.root}/spec/fixtures/files/test_image.jpg") }

    trait :pending_delivery do
      after(:build) do |item|
        item.offers << FactoryGirl.create(:offer, :with_purchase_complete_order)
      end
    end

    trait :shipped do
      after(:build) do |item|
        item.offers << FactoryGirl.create(:offer, :with_shipped_order)
      end
    end
  end
end
