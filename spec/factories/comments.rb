FactoryBot.define do
  sequence :content do |n|
    "CommentContent#{n}"
  end

  factory :comment do
    content
  end
end
