class User < ApplicationRecord
  belongs_to :lockbox_partner, optional: true
  has_many :support_requests

  # all but :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable,
         :timeoutable

  scope :confirmed, -> { where.not(confirmed_at: nil) }

  def has_signed_in?
    !!last_sign_in_at
  end

  private

  def password_required?
    confirmed? ? super : false
  end
end
