FactoryBot.define do
  factory :contact do
    name { FFaker::Name.name }
    email { FFaker::Internet.email }
    sequence(:phone) { |n| "123-456-#{n.to_s.rjust(3, '0')}" }
    association :user
  end
end
