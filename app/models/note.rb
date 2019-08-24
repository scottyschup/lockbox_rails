class Note < ApplicationRecord
  belongs_to :notable, polymorphic: true
  belongs_to :user
  validates :text, presence: true

  def author
    return user.name if user
    "System Generated"
  end
end
