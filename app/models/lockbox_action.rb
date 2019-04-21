class LockboxAction < ApplicationRecord
  belongs_to :lockbox_partner
  has_many :lockbox_transactions
  has_many :notes, as: :notable
end
