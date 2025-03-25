module Rents
  class SendEmail
    include Interactor

    def call
      SendRentConfirmationEmailJob.perform_later(context.rent.user, context.rent)
    end
  end
end
