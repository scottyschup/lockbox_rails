require 'rails_helper'

describe LockboxPartners::UsersController do
  let(:lockbox_partner) { create(:lockbox_partner, :active) }
  let(:user) { create(:user, role: 'admin', lockbox_partner: lockbox_partner) }
  let(:back) { "from when I came" }

  before do
    sign_in(user)
    request.env["HTTP_REFERER"] = back
  end

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

        expect { post :create, params: params }
          .to change { lockbox_partner.users.count }
          .by(1)

        expect(response).to redirect_to(back)
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

        expect { post :create, params: erroneous_params }
          .not_to change { lockbox_partner.users.count }

        expect(response).to render_template(:index)
      end
    end
  end

  describe '#update' do
    let(:user_to_update) { FactoryBot.create(:user, lockbox_partner: lockbox_partner) }
    let(:base_params) do
      {
        lockbox_partner_id: lockbox_partner.id,
        id: user_to_update.id
      }
    end

    context 'when params does not contain lock_user' do
      let(:params) { base_params }

      it 'does nothing' do
        expect { patch :update, params: params }
          .not_to change { user_to_update.reload.status }
        expect(response.status).to eq(400)
      end
    end

    context 'when params includes lock_user' do
      let(:params) { base_params.merge(update_action: update_action) }

      context 'when locking the account' do
        let(:update_action) { 'lock' }
        before { user_to_update.update!(locked_at: nil) }

        it 'locks the account' do
          expect { patch :update, params: params }
            .to change { user_to_update.reload.status }
            .from("active")
            .to("locked")
          expect(response).to redirect_to(back)
        end
      end

      context 'when unlocking the account' do
        let(:update_action) { 'unlock' }
        before { user_to_update.update!(locked_at: Time.current) }

        it 'unlocks the account' do
          expect { patch :update, params: params }
            .to change { user_to_update.reload.status }
            .from("locked")
            .to("active")
          expect(response).to redirect_to(back)
        end
      end
    end
  end

  describe '#resend_invite' do
    let(:user_to_invite) { FactoryBot.create(:user, lockbox_partner: lockbox_partner) }
    let(:params) do
      {
        lockbox_partner_id: lockbox_partner.id,
        user_id: user_to_invite.id
      }
    end
    it 'resends account confirmation instructions' do
      expect { get :resend_invite, params: params }
        .to change { ActionMailer::Base.deliveries.count }
        .by(1)
      mail = ActionMailer::Base.deliveries.last
      expect(mail.subject).to eq('Confirmation instructions')
      expect(mail.to.first).to eq(user_to_invite.email)
    end
  end
end
