class Book < ApplicationRecord
  validates :genre, :title, :author, :publisher, :year, :image, presence: true
  validates :year, numericality: { only_integer: true, greater_than: 0 }

  validates_uniqueness_of :title, scope: :author
end