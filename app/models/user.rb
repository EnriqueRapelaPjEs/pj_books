class User < ApplicationRecord
  has_many :book_suggestions, dependent: :destroy

  validates :email, :name, :last_name, presence: true

  validates_uniqueness_of :email
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
