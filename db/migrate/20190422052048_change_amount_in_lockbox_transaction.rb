class ChangeAmountInLockboxTransaction < ActiveRecord::Migration[6.0]
  def change
    rename_column :lockbox_transactions, :amount, :amount_cents
  end
end
