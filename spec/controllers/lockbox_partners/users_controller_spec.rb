require 'rails_helper'

describe LockboxPartners::UsersController do
  let(:lockbox_partner) { create(:lockbox_partner, :active) }
  let(:user) { create(:user, role: 'admin', lockbox_partner: lockbox_partner) }

  before { sign_in(user) }

  describe '#create' do
    let(:params) do
      {
        lockbox_partner_id: lockbox_partner.id,
        user: {
          name: 'Panda Face',
          email: 'sleepypanda@faces.com'
        }
      }
    end

    let(:flash) { instance_double("flash").as_null_object }

    before do
      allow_any_instance_of(LockboxPartners::UsersController)
        .to receive(:flash)
        .and_return(flash)
    end

    context 'when the user creation is successful' do
      it 'notifies the user and reloads the page' do
        expect(flash)
          .to receive(:clear)
          .once
        expect(flash)
          .to receive(:[]=)
          .with(:notice, "New user created for Lockbox Partner #{lockbox_partner.name}")

        post :create, params: params
      end
    end

    context 'when user creation fails' do
      let(:erroneous_params) do
        {
          lockbox_partner_id: lockbox_partner.id,
          user: {
            name: 'Panda Face'
          }
        }
      end

      it 'flashes the error' do
        expect(flash)
          .to receive(:[]=)
          .with(:alert, "Email can't be blank")

        post :create, params: erroneous_params
      end
    end
  end

  describe '#update' do
    context 'when params does not contain lock_user' do
      it 'does nothing' do

      end
    end

    context 'when params includes lock_user' do
      context 'when lock_user is true' do
        it 'locks the account' do

        end
      end

      context 'when lock_user is false' do
        it 'unlocks the account' do

        end
      end
    end
  end

  describe '#resend_invite' do
    it 'resends account confirmation instructions' do

    end
  end
end
