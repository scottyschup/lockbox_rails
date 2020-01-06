class Note < ApplicationRecord
  belongs_to :notable, polymorphic: true
  belongs_to :user, optional: true
  validates :text, presence: true

  after_create :send_alerts

  def author
    if user
      user.display_name
    else
      "System Generated"
    end
  end

  def system_generated?
    user_id.blank?
  end

  private

  def send_alerts
    NoteMailer.deliver_note_creation_alerts(self)
  end
end
