FactoryBot.define do
  factory :user do
    email           { Faker::Internet.email }
    name            { Faker::Name.name }
    last_name       { Faker::Name.last_name }
  end
end
