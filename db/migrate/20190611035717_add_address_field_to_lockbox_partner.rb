class AddAddressFieldToLockboxPartner < ActiveRecord::Migration[6.0]
  def change
    add_column :lockbox_partners, :street_address, :string
    add_column :lockbox_partners, :city, :string
    add_column :lockbox_partners, :state, :string
    add_column :lockbox_partners, :zip_code, :string

    remove_column :lockbox_partners, :address
  end
end
