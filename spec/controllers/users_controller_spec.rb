require 'rails_helper'

describe UsersController do
  let(:user)       { create(:user, name: "Peaches", role: 'admin') }
  let(:other_user) { create(:user, role: 'partner') }
  let(:back)       { "from whence I came" }

  before do
    sign_in(user)
    request.env["HTTP_REFERER"] = back
  end

  describe '#edit' do

  end

  describe '#update' do

  end

  context 'When the user owns the account' do
    before { get :edit, params: { id: user.id } }

    it "allows the update" do
      expect(response.status).to eq(200)
      expect { patch :update, params: { id: user.id, name: "Matilda" } }
        .to change { user.name }
        .from("Peaches")
        .to("Matilda")
    end
  end

  context 'When the user does not own the account' do

    let(:flash) { instance_double("flash").as_null_object }

    before do
      allow_any_instance_of(LockboxPartners::UsersController)
        .to receive(:flash)
        .and_return(flash)
    end

    it "does not allow access up updating" do
      get :edit, params: { id: other_user }
      expect(response).to redirect_to(back)
    end
  end
end