FactoryBot.define do
  sequence :title do |n|
    "QuestionTitle#{n}"
  end

  factory :question do
    title
    body { "MyText" }

    trait :unique do
      title { 'a question' }
    end

    trait :invalid do
      title { nil }
      body { nil }
    end
  end
end
