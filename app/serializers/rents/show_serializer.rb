module Rents
  class ShowSerializer < ActiveModel::Serializer
    attributes :id, :start_date, :end_date

    has_one :book
    has_one :user
  end
end
