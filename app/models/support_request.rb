class SupportRequest < ApplicationRecord
  belongs_to :lockbox_partner
  belongs_to :user
  has_many :lockbox_actions

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

  Note = Struct.new(:eff_date, :author, :content)

  def notes
    [
      Note.new(Date.yesterday-3, 'Some Author', 'Her ya go with some note content'),
      Note.new(Date.yesterday-2, 'Somebody', 'Her ya go with some note content'),
      Note.new(Date.current, 'Another person', 'Her ya go with some note content')
    ]
  end

  private

  def populate_client_ref_id
    self.client_ref_id = SecureRandom.uuid if client_ref_id.blank?
  end
end
