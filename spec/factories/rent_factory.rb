FactoryBot.define do
  factory :rent do
    start_date      { Faker::Date.between(from: 1.month.ago, to: 1.month.from_now) }
    end_date        { Faker::Date.between(from: 1.month.from_now, to: 2.months.from_now) }
    book            { create(:book) }
    user            { create(:user) }
  end
end
