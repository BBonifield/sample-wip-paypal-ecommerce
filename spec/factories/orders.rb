# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :order do
    association :shipping_address, :factory => :address
    association :offer, :accepted
    terms_and_conditions "1"

    after(:build) do |order|
      # setup addresses on order
      if order.offer.present?
        buyer = order.offer.posting.user
        order.shipping_address = FactoryGirl.create( :address, :user => buyer ) if order.shipping_address.blank?
      end
    end

    trait :new do
      state { Order::STATE_NEW }
    end
    trait :purchase_failed do
      state { Order::STATE_PURCHASE_FAILED }
    end
    trait :purchase_abandoned do
      state { Order::STATE_PURCHASE_ABANDONED }
    end
    trait :purchase_cancelled do
      state { Order::STATE_PURCHASE_CANCELLED }
    end
    trait :purchase_complete do
      purchase
      state { Order::STATE_PURCHASE_COMPLETE }
    end
    trait :shipped do
      purchase
      state { Order::STATE_SHIPPED }
    end
  end
end
