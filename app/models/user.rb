class User < ApplicationRecord
  validates :email, :name, :last_name, presence: true

  validates_uniqueness_of :email
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
