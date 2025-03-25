class SendRentConfirmationEmailJob < ApplicationJob
  queue_as :default

  def perform(user, rent)
    UserMailer.rent_confirmation_email(user, rent).deliver_later
  end
end
