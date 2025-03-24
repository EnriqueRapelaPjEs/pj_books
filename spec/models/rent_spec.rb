require 'rails_helper'

RSpec.describe Rent, type: :model do
  subject { build(:rent) }

  it { is_expected.to be_valid }

  it { is_expected.to validate_presence_of(:start_date) }
  it { is_expected.to validate_presence_of(:end_date) }
  it { should belong_to(:book) }
  it { should belong_to(:user) }

  it 'validates end_date_after_start_date' do
    rent = build(:rent, start_date: Date.today, end_date: Date.today - 1.day)
    expect(rent).not_to be_valid
    expect(rent.errors.full_messages).to include('End date must be after start date')
  end
end
