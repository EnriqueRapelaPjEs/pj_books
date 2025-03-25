module OpenLibrary
  class BookHash
    attr_reader :book_data

    def initialize(book_data)
      @book_data = book_data
    end

    def call
      isbn = @book_data.keys.first.split(':').last
      get_book_data(@book_data.values[0], isbn)
    end

    private

    def get_book_data(json_data, isbn)
      {
        ISBN: isbn,
        title: json_data['title'],
        subtitle: json_data['subtitle'],
        number_of_pages: json_data['number_of_pages'],
        authors: json_data['authors']&.map { |author| author['name'] }&.join(', ')
      }
    end
  end
end
