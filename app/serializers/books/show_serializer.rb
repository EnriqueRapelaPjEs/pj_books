module Books
  class ShowSerializer < ActiveModel::Serializer
    attributes :id, :title, :author, :publisher, :year, :image
  end
end
