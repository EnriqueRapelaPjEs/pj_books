class CheckRentingExpiryWorker
  include Sidekiq::Worker

  def perform
    rents_soon_to_end = Rent.where('end_date = ?', Date.today)

    rents_soon_to_end.each do |rent|
      UserMailer.renting_expiring(rent.user, rent).deliver_later
    end
  end
end
