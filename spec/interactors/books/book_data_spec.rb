RSpec.describe Books::BookData do
  describe '#call' do
    let(:isbn) { '9780123456789' }
    let(:service_instance) { instance_double(OpenLibrary::Service) }
    let(:book_data) { { 'title' => 'Example Book' } }

    before do
      allow(OpenLibrary::Service).to receive(:new).and_return(service_instance)
      allow(service_instance).to receive(:fetch).with(isbn).and_return(book_data)
    end

    it 'calls the OpenLibrary service with the provided ISBN' do
      result = described_class.call(isbn: isbn)

      expect(service_instance).to have_received(:fetch).with(isbn)
      expect(result.book_data).to eq(book_data)
    end
  end
end
