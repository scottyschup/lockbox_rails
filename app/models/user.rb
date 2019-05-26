class User < ApplicationRecord
  belongs_to :lockbox_partner, optional: true
  has_many :support_requests

  # all but :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable,
         :timeoutable

  scope :confirmed, -> { where.not(confirmed_at: nil) }

  ROLES = [
    ADMIN  = 'admin',
    PARTNER = 'partner'
  ].freeze

  def admin?
    role == ADMIN
  end

  def partner?
    role == PARTNER
  end

  private

  def password_required?
    confirmed? ? super : false
  end
end
