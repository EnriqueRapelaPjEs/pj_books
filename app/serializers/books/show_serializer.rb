module Books
  class ShowSerializer < ActiveModel::Serializer
    attributes :id, :title, :author, :publisher, :year, :image

    has_many :book_suggestions, serializer: BookSuggestions::ShowSerializer
  end
end
