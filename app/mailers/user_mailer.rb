class UserMailer < ApplicationMailer
  default from: 'no-reply@pjespana.es'

  def rent_confirmation_email(user, rent)
    @user = user
    @rent = rent
    @book = rent.book

    mail(to: @user.email, subject: 'Confirmación de tu alquiler')
  end
end
