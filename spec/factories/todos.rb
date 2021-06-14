FactoryBot.define do
  factory :todo do
    sequence(:title) { |n| "title ##{n}" }
    sequence(:description) { |n| "description ##{n}" }
    deadline { DateTime.now + 1.day }
  end
end