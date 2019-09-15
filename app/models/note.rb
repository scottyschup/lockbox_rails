class Note < ApplicationRecord
  belongs_to :notable, polymorphic: true
  belongs_to :user
  validates :text, presence: true

  def author
    if user
      user.name || "User #{user.id}"
    else
      "System Generated"
    end
  end
end
