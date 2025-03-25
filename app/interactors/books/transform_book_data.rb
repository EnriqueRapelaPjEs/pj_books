module Books
  class TransformBookData
    include Interactor

    def call
      context.fail!(error: Error.book_not_found(context.isbn)) if context.book_data.blank?

      context.book_hash = OpenLibrary::BookHash.new(context.book_data).call
    end
  end
end
