module Users
  class IndexSerializer < ActiveModel::Serializer
    attributes :id, :email, :name, :last_name
  end
end
