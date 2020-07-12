require 'rails_helper'

describe LowBalanceAlertWorker do
  let(:lockbox_partner) { FactoryBot.create(:lockbox_partner) }

  before do
    described_class.perform_async(params)
  end

  context 'When params does not include an alert' do
    let(:params) do
      {
        'alert': '',
        'lockbox_partner_id': lockbox_partner.id
      }
    end

    it 'does not attempt to send an email' do
      expect(LockboxPartnerMailer).not_to receive(:with)
      LowBalanceAlertWorker.drain
    end
  end

  context 'When params includes an alert but no valid lockbox partner id' do
    let(:params) do
      {
        'alert': 'insufficient_funds',
        'lockbox_partner_id': 'bleepybloop'
      }
    end

    it 'does not attempt to send an email' do
      expect(LockboxPartnerMailer).not_to receive(:with)
      LowBalanceAlertWorker.drain
    end
  end

  context 'When params include alert and lockbox_partner_id' do
    let(:params) do
      {
        'alert': alert_string,
        'lockbox_partner_id': lockbox_partner.id
      }
    end

    let(:insufficient_funds_dbl) { double(deliver_now: true) }
    let(:low_balance_dbl)        { double(deliver_now: true) }

    let(:mailer_double) do
      instance_double(LockboxPartnerMailer,
        insufficient_funds_alert: insufficient_funds_dbl,
        low_balance_alert:        low_balance_dbl
      )
    end

    before do
      allow(LockboxPartnerMailer)
        .to receive(:with)
        .with(lockbox_partner: lockbox_partner)
        .and_return(mailer_double)
    end

    context 'alert is for insufficient funds' do
      let(:alert_string) { 'insufficient_funds' }

      it 'triggers the insufficient funds email' do
        expect(low_balance_dbl).not_to receive(:deliver_now)
        expect(insufficient_funds_dbl).to receive(:deliver_now)
        LowBalanceAlertWorker.drain
      end
    end

    context 'alert is for low balance' do
      let(:alert_string) { 'low_balance' }

      it 'triggers the low balance email' do
        expect(insufficient_funds_dbl).not_to receive(:deliver_now)
        expect(low_balance_dbl).to receive(:deliver_now)
        LowBalanceAlertWorker.drain
      end
    end

    context 'alert is for something else' do
      let(:alert_string) { 'tacos' }

      it 'does not attempt to send an email' do
        expect(LockboxPartnerMailer).not_to receive(:with)
        LowBalanceAlertWorker.drain
      end
    end
  end
end