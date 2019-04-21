class SupportRequest < ApplicationRecord
  belongs_to :lockbox_partner
  belongs_to :user
  has_many :lockbox_actions
end
