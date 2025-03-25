module Books
  class BookDataByIsbn
    include Interactor::Organizer

    organize BookData, TransformBookData
  end
end
