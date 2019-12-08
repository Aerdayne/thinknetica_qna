FactoryBot.define do
  factory :link do
    name { "A link" }
    url { "http://google.com" }
  end

  trait :invalid do
    url { "invalid url" }
  end

  trait :gist do
    name { "Gist link" }
    url { "https://gist.github.com/jacksonfdam/3000275" }
  end
end
