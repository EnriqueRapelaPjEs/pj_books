module Users
  class ShowSerializer < ActiveModel::Serializer
    attributes :id, :email, :name, :last_name
  end
end
