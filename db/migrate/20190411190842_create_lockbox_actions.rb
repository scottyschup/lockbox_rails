class CreateLockboxActions < ActiveRecord::Migration[6.0]
  def change
    create_table :lockbox_actions do |t|
      t.date :eff_date
      t.string :action_type
      t.string :status
      t.references :lockbox_partner

      t.timestamps
    end
  end
end
