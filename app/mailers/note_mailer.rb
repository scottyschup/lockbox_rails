class NoteMailer < ApplicationMailer

  def note_creation_alert
    @note = params[:note]

    if @note.system_generated?
      subject = "New System note on #{@note.notable_type.titleize} ##{@note.notable_id}"
    else
      subject = "New note from #{@note.author} on #{@note.notable_type.titleize} ##{@note.notable_id}"
    end

    mail(to: params[:address], subject: subject)
  end

  def self.deliver_note_creation_alerts(note)
    recipients(note).collect do |email|
      NoteMailer.with(note: note, address: email).note_creation_alert.deliver_now
    end
  end

  private

  def self.recipients(note)
    # MAC users only get emailed about manual notes
    # MAC users don't get emailed about notes they wrote
    users = User.admin.all
    users -= [note.user]

    # Partner users get emailed about all notes
    users.concat(note.notable.try(:lockbox_partner).try(:users))
    
    users.collect(&:email)
  end
end
