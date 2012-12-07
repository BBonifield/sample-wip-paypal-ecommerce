# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :offer do
    posting
    inventory_item
    price "9.99"

    trait :accepted do
      state { Offer::STATE_ACCEPTED }
    end

    trait :declined do
      state { Offer::STATE_DECLINED }
    end

    trait :with_purchase_complete_order do
      accepted
      association :order, :purchase_complete
    end

    trait :with_shipped_order do
      accepted
      association :order, :shipped
    end
  end
end
