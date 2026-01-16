FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    password { 'password123' }
    password_confirmation { 'password123' }
    auth_token { SecureRandom.hex(24) }
  end
end
