FactoryBot.define do
  sequence :body do |n|
    "AnswerBody#{n}"
  end

  factory :answer do
    body

    trait :invalid do
      body { nil }
    end

    trait :unique do
      body { 'an answer' }
    end

    trait :other do
      body { 'other' }
    end
  end
end
