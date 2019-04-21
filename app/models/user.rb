class User < ApplicationRecord
  # all but :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable,
         :timeoutable

  has_many :support_requests
end
