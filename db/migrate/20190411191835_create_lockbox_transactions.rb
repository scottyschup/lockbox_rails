class CreateLockboxTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :lockbox_transactions do |t|
      t.date :eff_date
      t.string :type
      t.string :category
      t.integer :amount
      t.references :lockbox_action, foreign_key: true

      t.timestamps
    end
  end
end
