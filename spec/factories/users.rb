FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email { "test@test.com" }
    password { "testtest" }
  end
end
