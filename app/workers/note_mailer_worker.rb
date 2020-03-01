class NoteMailerWorker
  include Sidekiq::Worker

  def perform(note_id)
    note = Note.find_by(id: note_id)
    return unless note
    NoteMailer.deliver_note_creation_alerts(note)
  end
end
