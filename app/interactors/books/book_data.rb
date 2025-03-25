module Books
  class BookData
    include Interactor

    def call
      context.book_data = ::OpenLibrary::Service.new.fetch(context.isbn)
    end
  end
end
