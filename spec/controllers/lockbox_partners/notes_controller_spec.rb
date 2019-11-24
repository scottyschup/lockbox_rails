require 'rails_helper'

describe LockboxPartners::NotesController do
  let(:lockbox_partner) { FactoryBot.create(:lockbox_partner, :active) }
  let(:user) { FactoryBot.create(:user) }

  let(:support_request) do
    FactoryBot.create(
      :support_request,
      :pending,
      lockbox_partner: lockbox_partner
    )
  end

  let(:user_generated_note) do
    FactoryBot.create(:note, notable: support_request, text: 'old text')
  end

  let(:system_generated_note) do
    FactoryBot.create(
      :note,
      notable: support_request,
      user: nil,
      text: 'old text'
    )
  end

  before { sign_in(user) }

  describe '#edit' do
    before do
      get :edit, params: {
        lockbox_partner_id: lockbox_partner.id,
        support_request_id: support_request.id,
        id: note.id
      }
    end

    context 'when the note was system-generated' do
      let(:note) { system_generated_note }

      it 'returns 401' do
        expect(response.status).to eq(401)
      end
    end

    context 'when the note was user-generated' do
      let(:note) { user_generated_note }

      it 'returns 200' do
        expect(response.status).to eq(200)
      end
    end
  end

  describe '#update' do
    before do
      patch :update, params: {
        lockbox_partner_id: lockbox_partner.id,
        support_request_id: support_request.id,
        id: note.id,
        note: { text: 'new text' }
      }
    end

    context 'when the note was system-generated' do
      let(:note) { system_generated_note }

      it 'returns 401' do
        expect(response.status).to eq(401)
      end

      it 'does not update the text' do
        expect(note.reload.text).to eq('old text')
      end
    end

    context 'when the note was user-generated' do
      let(:note) { user_generated_note }

      it 'returns 200' do
        expect(response.status).to eq(200)
      end

      it 'updates the text' do
        expect(note.reload.text).to eq('new text')
      end
    end
  end
end
