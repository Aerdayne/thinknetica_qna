include ActionDispatch::TestProcess

FactoryBot.define do
  sequence :body do |n|
    "AnswerBody#{n}"
  end

  factory :answer do
    body
    best { false }

    trait :invalid do
      body { nil }
      best { false }
    end

    trait :unique do
      body { 'an answer' }
      best { false }
    end

    trait :other do
      body { 'other' }
      best { false }
    end
  end
end
