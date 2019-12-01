FactoryBot.define do
  factory :question do
    sequence :title do |n|
      "QuestionTitle#{n}"
    end
  
    sequence :body do |n|
      "QuestionBody#{n}"
    end

    trait :unique do
      title { 'a question' }
    end

    trait :invalid do
      title { nil }
      body { nil }
    end
  end
end
