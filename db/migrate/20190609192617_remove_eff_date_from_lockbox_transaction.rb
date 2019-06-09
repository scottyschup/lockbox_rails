class RemoveEffDateFromLockboxTransaction < ActiveRecord::Migration[6.0]
  def change
    remove_column :lockbox_transactions, :eff_date
  end
end
