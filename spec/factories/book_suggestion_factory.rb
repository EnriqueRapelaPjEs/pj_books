FactoryBot.define do
  factory :book_suggestion do
    link            { Faker::Internet.url }
    price           { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    book            { create(:book) }
    user            { create(:user) }
  end
end
