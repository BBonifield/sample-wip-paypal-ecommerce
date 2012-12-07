# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :mass_assignable_posting, :class => Posting do
    name { Faker::Lorem.words(3).join(" ") }
    category_id { FactoryGirl.create(:category).id }
    condition_id { FactoryGirl.create(:condition).id }
    shipping_speed_id { FactoryGirl.create(:shipping_speed).id }
    price { 1 + (Random.rand * 1000).ceil / 100 }
    details { Faker::Lorem.paragraphs(3).join("\n\n") }
  end

  factory :posting do
    name { Faker::Lorem.words(3).join(" ") }
    category
    condition
    user
    price { 1 + (Random.rand * 1000).ceil / 100 }
    details { Faker::Lorem.paragraphs(3).join("\n\n") }
    posting_image { File.open("#{Rails.root}/spec/fixtures/files/test_image.jpg") }

    trait :purchase_pending do
      state { Posting::STATE_PURCHASE_PENDING }
    end
  end
end
