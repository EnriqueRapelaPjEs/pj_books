class UserMailer < ApplicationMailer
  default from: 'no-reply@pjespana.es'

  def rent_confirmation_email(user, rent)
    @user = user
    @rent = rent
    @book = rent.book

    mail(to: @user.email, subject: 'Confirmación de tu alquiler')
  end

  def renting_expiring(user, rent)
    @user = user
    @rent = rent
    @book = rent.book

    mail(to: @user.email, subject: 'El alquiler de tu libro finaliza hoy')
  end
end
