module Books
  class CheckBookAvailability
    include Interactor

    def call
      existing_rent = Rent.find_by('book_id = ? AND end_date > ? AND start_date < ?', context.book_id,
                                   context.start_date, context.end_date)

      context.fail!(error: Error.book_already_rented(existing_rent.book_id)) if existing_rent
    end
  end
end
