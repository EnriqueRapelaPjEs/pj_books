require 'rails_helper'

RSpec.describe BookSuggestion, type: :model do
  subject { build(:book_suggestion) }

  it { is_expected.to be_valid }

  it { is_expected.to validate_presence_of(:link) }

  it { is_expected.to validate_numericality_of(:price).is_greater_than(0) }
end
