class Note < ApplicationRecord
  belongs_to :notable, polymorphic: true
  belongs_to :user, optional: true
  validates :text, presence: true

  def author
    if user
      user.display_name
    else
      "System Generated"
    end
  end
end
