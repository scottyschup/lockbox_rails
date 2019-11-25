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
          .not_to change { user.locked? }
        expect(response.status).to eq(400)
      end
    end

    context 'when params includes lock_user' do
      let(:params) { base_params.merge(lock_user: should_lock) }

      context 'when lock_user is true' do
        let(:should_lock) { true }
        before { user_to_update.update!(locked_at: nil) }

        it 'locks the account' do
          expect { patch :update, params: params }
            .to change { user_to_update.reload.status }
            .from("active")
            .to("locked")
        end
      end

      context 'when lock_user is false' do
        let(:should_lock) { false }
        before { user_to_update.update!(locked_at: Time.current) }

        it 'unlocks the account' do
          expect { patch :update, params: params }
            .to change { user_to_update.reload.status }
            .from("locked")
            .to("active")
        end
      end
    end
  end

  describe '#resend_invite' do
    it 'resends account confirmation instructions' do

    end
  end
end
