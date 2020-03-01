require 'rails_helper'

describe NoteMailerWorker do
  context 'the note exists' do
    let!(:note) { create(:note) }
    it 'sends the necessary emails' do
      expect {
        subject.perform(note.id)
      }.to change { ActionMailer::Base.deliveries.length }.by(1)
    end
  end

  context 'the note does not exist' do
    it 'sends no emails' do
      expect {
        subject.perform(1337)
      }.not_to change { ActionMailer::Base.deliveries.length }
    end
  end
end
