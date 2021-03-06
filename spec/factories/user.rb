FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    slack_handle { Faker::Internet.email.split('@')[0] }
  end
end