# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ipn_notification do
    raw_post "somekey=asdf&someotherkey=1234"

    trait :completed do
      status "COMPLETED"
    end
  end
end
