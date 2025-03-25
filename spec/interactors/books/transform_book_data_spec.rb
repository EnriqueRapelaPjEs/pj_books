RSpec.describe Books::TransformBookData do
  describe '#call' do
    let(:isbn) { '9780123456789' }
    let(:book_data) { { 'title' => 'Example Book' } }
    let(:transformed_data) { { title: 'Example Book' } }
    let(:book_hash_instance) { instance_double(OpenLibrary::BookHash) }

    context 'when book_data is present' do
      before do
        allow(OpenLibrary::BookHash).to receive(:new).with(book_data).and_return(book_hash_instance)
        allow(book_hash_instance).to receive(:call).and_return(transformed_data)
      end

      it 'transforms the book data using BookHash' do
        result = described_class.call(book_data: book_data, isbn: isbn)

        expect(OpenLibrary::BookHash).to have_received(:new).with(book_data)
        expect(book_hash_instance).to have_received(:call)
        expect(result.book_hash).to eq(transformed_data)
      end
    end

    context 'when book_data is blank' do
      let(:book_data) { nil }

      it 'fails with book not found error' do
        result = described_class.call(book_data: book_data, isbn: isbn)

        expect(result).to be_failure
      end
    end
  end
end
