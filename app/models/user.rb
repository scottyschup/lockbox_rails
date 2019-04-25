class User < ApplicationRecord
  belongs_to :lockbox_partner, optional: true

  # all but :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable,
         :timeoutable
end
