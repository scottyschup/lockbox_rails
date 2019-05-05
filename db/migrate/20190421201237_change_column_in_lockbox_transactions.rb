class ChangeColumnInLockboxTransactions < ActiveRecord::Migration[6.0]
  def change
    rename_column :lockbox_transactions, :type, :balance_effect
  end
end
