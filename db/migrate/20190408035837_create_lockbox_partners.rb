class CreateLockboxPartners < ActiveRecord::Migration[6.0]
  def change
    create_table :lockbox_partners do |t|
      t.string :name
      t.string :address
      t.string :phone_number

      t.timestamps
    end
  end
end
