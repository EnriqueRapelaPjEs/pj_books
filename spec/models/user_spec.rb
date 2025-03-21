require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  it { is_expected.to be_valid }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:last_name) }

  it { is_expected.to validate_uniqueness_of(:email) }

  describe 'email format' do
    it 'is valid with a proper email format' do
      subject.email = 'test@example.com'
      expect(subject).to be_valid
    end

    it 'is invalid with an improper email format' do
      subject.email = 'invalid-email'
      expect(subject).not_to be_valid
      expect(subject.errors[:email]).to include('is invalid')
    end
  end
end
