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

  def self.create_with_action(params)
    ActiveRecord::Base.transaction do
      create!(
        lockbox_partner_id: params[:lockbox_partner_id],
        name_or_alias: params[:name_or_alias],
        user_id: params[:user_id]
      ).tap do |support_request|
        support_request.lockbox_actions.create_with_transactions(
          LockboxAction::SUPPORT_CLIENT, params
        )
      end
    end
  end

  private

  def populate_client_ref_id
    self.client_ref_id = SecureRandom.uuid if client_ref_id.blank?
  end
end
