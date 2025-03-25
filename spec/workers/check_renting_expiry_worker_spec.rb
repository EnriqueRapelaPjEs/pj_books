require 'rails_helper'

RSpec.describe CheckRentingExpiryWorker do
  describe '#perform' do
    let(:user) { create(:user) }
    let(:expired_rent) { create(:rent, start_date: Date.today - 1.day, end_date: Date.today, user: user) }
    let(:correct_rent) { create(:rent, start_date: Date.today, end_date: Date.today + 1.day, user: user) }

    it 'enqueues the worker' do
      expect do
        described_class.perform_async
      end.to change(described_class.jobs, :size).by(1)
    end

    it 'sends an email to the user when a renting is expiring today' do
      mailer_double = double('mailer_double', deliver_later: true)
      allow(UserMailer).to receive(:renting_expiring)
        .with(user, expired_rent)
        .and_return(mailer_double)

      described_class.new.perform

      expect(UserMailer).to have_received(:renting_expiring).with(user, expired_rent)
    end

    it 'does not send an email if the renting is not expiring today' do
      allow(UserMailer).to receive(:renting_expiring)

      described_class.new.perform

      expect(UserMailer).not_to have_received(:renting_expiring)
    end
  end
end
