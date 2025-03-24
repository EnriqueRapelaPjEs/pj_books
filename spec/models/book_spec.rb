require 'rails_helper'

RSpec.describe Book, type: :model do
  subject { build(:book) }

  it { is_expected.to be_valid }

  it { is_expected.to validate_presence_of(:genre) }
  it { is_expected.to validate_presence_of(:author) }
  it { is_expected.to validate_presence_of(:image) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:publisher) }
  it { is_expected.to validate_presence_of(:year) }

  it { is_expected.to validate_numericality_of(:year).is_greater_than(0) }

  it { is_expected.to validate_uniqueness_of(:title).scoped_to(:author) }
end
