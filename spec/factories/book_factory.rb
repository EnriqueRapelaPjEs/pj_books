FactoryBot.define do
  factory :book do
    genre           { Faker::Book.genre }
    author          { Faker::Book.author }
    image           { Faker::Lorem.word }
    title           { Faker::Book.title }
    publisher       { Faker::Book.publisher }
    year            { Faker::Number.number(digits: 4).to_i }
  end
end
