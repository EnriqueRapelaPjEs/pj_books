module Rents
  class Create
    include Interactor

    def call
      Rent.transaction do
        rent = Rent.new(book: book, user: user, start_date: context.start_date, end_date: context.end_date)

        if rent.save
          context.rent = rent
        else
          context.fail!(error: Error.field_validation_error(rent))
        end
      end
    end

    private

    def book
      @book ||= Book.find(context.book_id)
    end

    def user
      @user ||= User.find(context.user_id)
    end
  end
end
