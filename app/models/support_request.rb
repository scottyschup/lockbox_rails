class SupportRequest < ApplicationRecord
  belongs_to :lockbox_partner
  has_many :lockbox_actions
end
