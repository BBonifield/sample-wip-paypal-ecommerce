# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shipping_notification do
    order_id { FactoryGirl.create(:order, :purchase_complete).id }
    shipping_service_id { FactoryGirl.create(:shipping_service).id }
    tracking_number { Faker::Lorem.characters(20) }
    note { Faker::Lorem.paragraphs.join("\n\n") }

  end
end
