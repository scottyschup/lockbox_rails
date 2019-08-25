class SupportRequest < ApplicationRecord
  belongs_to :lockbox_partner
  belongs_to :user
  has_one :lockbox_action
  has_many :notes, as: :notable

  validates :client_ref_id, presence: true
  validates :name_or_alias, presence: true
  validates :user, presence: true
  validates :lockbox_partner, presence: true

  # Sometimes the UUID will already have been created elsewhere, and sometimes not
  before_validation :populate_client_ref_id

  def self.pending_for_partner(lockbox_partner_id:)
    LockboxAction.where.not(support_request_id: nil)
      .where(lockbox_partner_id: lockbox_partner_id, status: LockboxAction::PENDING)
      .map(&:support_request)
  end

  def status
    lockbox_action.status
  end

  def amount
    lockbox_action.amount
  end

  def pickup_date
    lockbox_action.eff_date
  end

  def most_recent_note
    @most_recent_note ||= notes.last
  end

  private

  def populate_client_ref_id
    self.client_ref_id = SecureRandom.uuid if client_ref_id.blank?
  end
end
