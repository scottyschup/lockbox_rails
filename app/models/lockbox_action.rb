class LockboxAction < ApplicationRecord
  belongs_to :lockbox_partner
  belongs_to :support_request
  has_many :lockbox_transactions
  has_many :notes, as: :notable

  validates :eff_date, presence: true

  before_validation :inherit_lockbox_partner_id

  private

  def inherit_lockbox_partner_id
    if lockbox_partner_id.blank? && support_request&.lockbox_partner_id
      self.lockbox_partner_id = support_request.lockbox_partner_id
    end
  end
end
