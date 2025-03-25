module Books
  class ByIsbn
    include Interactor::Organizer

    organize BookData, TransformBookData
  end
end
