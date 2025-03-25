module BookSuggestions
  class IndexSerializer < ActiveModel::Serializer
    attributes :id, :synopsis, :price, :book_author, :book_title, :link, :book_publisher, :book_year, :user_name

    def book_author
      object.book.author
    end

    def book_title
      object.book.title
    end

    def book_publisher
      object.book.publisher
    end

    def book_year
      object.book.year
    end

    def user_name
      object.user.name
    end
  end
end
