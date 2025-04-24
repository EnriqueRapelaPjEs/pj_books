describe Rents::GenerateCreate do
  describe '#call' do
    subject(:generate_create) do
      described_class.call(book_id: book.id, start_date: start_date, end_date: end_date, user_id: user.id)
    end

    let(:book) { create(:book) }
    let(:start_date) { Date.today }
    let(:end_date) { Date.today + 1.day }
    let(:user) { create(:user) }
    let(:interactor_response) { double }

    before do
      allow(interactor_response).to receive(:success?).and_return(true)
      allow(Books::CheckBookAvailability).to receive(:call!).and_return(interactor_response)
      allow(Rents::Create).to receive(:call!).and_return(interactor_response)
    end

    it 'organized the right interactors' do
      expect(described_class.organized).to eq(
        [Books::CheckBookAvailability, Rents::Create, Rents::SendEmail]
      )
    end
  end
end
