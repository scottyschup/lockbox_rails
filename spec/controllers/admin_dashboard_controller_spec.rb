require 'rails_helper'

describe AdminDashboardController do
  let(:user) { create(:user) }
  before { sign_in user }

  describe '#index' do
    subject { get :index }

    context 'admin user' do
      it 'loads index template' do
        expect(subject).to render_template('index')
      end
    end

    context 'partner user' do
      before { user.update!(role: User::PARTNER) }

      it 'redirects the user to root' do
        expect(subject).to redirect_to('/')
      end
    end
  end

  describe '#create' do
    subject do
      post :create, params: {
        user: {
          name: Faker::Name.name,
          email: Faker::Internet.email,
          role: User::ADMIN
        }
      }
    end

    context 'admin user' do
      it 'creates a new user' do
        expect{subject}.to change{ User.count }.by 1
      end
    end

    context 'partner user' do
      before { user.update!(role: User::PARTNER) }

      it 'redirects the user to root' do
        expect(subject).to redirect_to('/')
      end
    end
  end
end