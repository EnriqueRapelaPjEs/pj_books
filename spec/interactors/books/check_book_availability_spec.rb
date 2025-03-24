describe Books::CheckBookAvailability do
  describe '#call' do
    let(:book) { create(:book) }
    let(:start_date) { Date.today }
    let(:end_date) { Date.today + 1.day }
    let(:rent) { create(:rent, book: book, start_date: start_date, end_date: end_date) }

    context 'when the book is not rented' do
      let(:subject) { described_class.call(book_id: book.id, start_date: start_date, end_date: end_date) }

      it 'returns a success' do
        expect(subject.success?).to be_truthy
      end
    end

    context 'when the book is already rented' do
      let(:subject) do
        described_class.call(book_id: rent.book_id, start_date: rent.start_date, end_date: rent.end_date)
      end

      it 'returns a failure' do
        expect(subject.success?).to be_falsey
      end
    end
  end
end
