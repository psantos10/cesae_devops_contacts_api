FactoryBot.define do
  factory :contact do
    name { FFaker::Name.name }
    email { FFaker::Internet.email }
    sequence(:phone) { |n| "123-456-78#{n}" }
  end
end
