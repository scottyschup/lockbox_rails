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

  # for greppability:
  # scope :pending
  # scope :completed
  # scope :canceled
  LockboxAction::STATUSES.each do |status|
    scope status, -> { joins(:lockbox_action).where("lockbox_actions.status": status) }
    scope "#{status}_for_partner", ->(lockbox_partner_id:) { joins(:lockbox_action).where(lockbox_partner_id: lockbox_partner_id, "lockbox_actions.status": status) }
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

  def status_options
    LockboxAction::STATUSES - [status]
  end

  def update_status_path(params)
    params = { lockbox_partner_id: lockbox_partner_id, support_request_id: id }.merge(params)
    Rails.application.routes.url_helpers
      .lockbox_partner_support_request_update_status_path(params)
  end

  private

  def populate_client_ref_id
    self.client_ref_id = SecureRandom.uuid if client_ref_id.blank?
  end
end
