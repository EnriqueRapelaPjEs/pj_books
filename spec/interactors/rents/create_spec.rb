describe Rents::Create do
  describe '#call' do
    let(:book) { create(:book) }
    let(:user) { create(:user) }
    let(:start_date) { Date.today }
    let(:end_date) { Date.today + 1.day }

    context 'when the book is not rented' do
      let(:subject) do
        described_class.call(book_id: book.id, start_date: start_date, end_date: end_date, user_id: user.id)
      end

      it 'returns a success' do
        expect(subject.success?).to be_truthy
      end
    end
  end
end
