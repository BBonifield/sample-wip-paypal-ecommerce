# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :mass_assignable_user, :class => User do
    user_name { Faker::Internet.user_name }
    email { Faker::Internet.email }
    password "somePassword1!"
    password_confirmation "somePassword1!"
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.first_name }

    addresses_attributes { [ FactoryGirl.attributes_for(:mass_assignable_address) ] }
  end

  factory :new_user_at_signup, :class => User do
    is_signing_up true
  end

  factory :user do
    user_name { Faker::Internet.user_name }
    email { Faker::Internet.email }
    password "somePassword1!"
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.first_name }

    after(:build) do |user|
      user.password_confirmation = user.password
    end

  end
end
