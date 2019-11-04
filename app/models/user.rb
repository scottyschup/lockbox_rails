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

  def has_signed_in?
    !!last_sign_in_at
  end

  def status
    return "pending" if confirmed_at.nil?
    return "locked" if locked_at.present?
    return "active"
  end

  def display_name
    self.name || "User #{id}"
  end

  private

  def password_required?
    confirmed? ? super : false
  end
end
