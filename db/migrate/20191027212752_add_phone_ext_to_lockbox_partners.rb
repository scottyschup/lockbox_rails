class AddPhoneExtToLockboxPartners < ActiveRecord::Migration[6.0]
  def change
    add_column :lockbox_partners, :phone_ext, :string
  end
end
