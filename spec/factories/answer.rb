FactoryBot.define do
  factory :answer do
    body { "MyString" }

    trait :invalid do
      body { nil }
    end

    trait :other do
      body { 'other' }
    end
  end
end
