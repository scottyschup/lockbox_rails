class SupportRequest < ApplicationRecord
  belongs_to :lockbox_partner
  belongs_to :user
  has_many :lockbox_actions
  accepts_nested_attributes_for :lockbox_actions
  has_many :lockbox_transactions, through: :lockbox_actions
  accepts_nested_attributes_for :lockbox_transactions, reject_if: :all_blank,
    allow_destroy: true
  has_many :notes, as: :notable

  validates :client_ref_id, presence: true
  validates :name_or_alias, presence: true
  validates :user, presence: true
  validates :lockbox_partner, presence: true

  # Sometimes the UUID will already have been created elsewhere, and sometimes not
  before_validation :populate_client_ref_id

  def lockbox_action
    @lockbox_action ||= lockbox_actions.last
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

  def editable_status?
    lockbox_action.editable_status?
  end

  private

  def populate_client_ref_id
    self.client_ref_id = SecureRandom.uuid if client_ref_id.blank?
  end
end
