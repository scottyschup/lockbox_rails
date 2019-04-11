class LockboxAction < ApplicationRecord
  belongs_to :lockbox_partner
  has_many :lockbox_transactions
end
