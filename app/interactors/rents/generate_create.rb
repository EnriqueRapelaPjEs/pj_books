module Rents
  class GenerateCreate
    include Interactor::Organizer

    organize Books::CheckBookAvailability,
             Create,
             SendEmail
  end
end
