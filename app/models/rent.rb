class Rent < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates :start_date, :end_date, presence: true
  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    return if end_date > start_date

    errors.add(:end_date, 'must be after start date')
  end
end
