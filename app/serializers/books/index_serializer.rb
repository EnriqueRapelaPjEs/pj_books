module Books
  class IndexSerializer < ActiveModel::Serializer
    attributes :id, :title, :author, :publisher, :year, :image
  end
end
