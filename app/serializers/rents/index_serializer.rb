module Rents
  class IndexSerializer < ActiveModel::Serializer
    attributes :id, :start_date, :end_date, :book_title, :user_name

    def book_title
      object.book.title
    end

    def user_name
      object.user.name
    end
  end
end
