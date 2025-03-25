RSpec.describe OpenLibrary::BookHash do
  describe '#call' do
    subject(:book_hash) { described_class.new(book_data).call }

    let(:book_data) do
      { 'ISBN:9780123456789' => { 'title' => 'Example Book', 'subtitle' => 'Subtitle', 'number_of_pages' => 100,
     'authors' => [{ 'name' => 'Author Name' }] } }
    end

    it 'returns the book data with OpenLibrary::BookHash PORO' do
      expect(book_hash).to eq({
                                ISBN: '9780123456789',
                                title: 'Example Book',
                                subtitle: 'Subtitle',
                                number_of_pages: 100,
                                authors: 'Author Name'
                              })
    end
  end
end
