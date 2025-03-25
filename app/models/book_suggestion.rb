class BookSuggestion < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates :link, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
end
