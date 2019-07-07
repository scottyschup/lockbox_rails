class Note < ApplicationRecord
  belongs_to :notable, polymorphic: true
  belongs_to :user
  validates :text, presence: true
end
