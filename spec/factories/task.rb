FactoryBot.define do
  factory :task do
    content { Faker::Food.description }
    reporter factory: :user
    assignee factory: :user
  end
end